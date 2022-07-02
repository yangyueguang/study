# 调用AI与人下五子棋
import random
import copy
from operator import itemgetter
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from torch.autograd import Variable
import numpy as np
from collections import defaultdict, deque


class Net(nn.Module):
    def __init__(self, board_width, board_height):
        super(Net, self).__init__()
        self.board_width = board_width
        self.board_height = board_height
        # 通用层 common layers
        self.conv1 = nn.Conv2d(4, 32, kernel_size=3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        self.conv3 = nn.Conv2d(64, 128, kernel_size=3, padding=1)
        # 行动策略层 action policy layers
        self.act_conv1 = nn.Conv2d(128, 4, kernel_size=1)
        self.act_fc1 = nn.Linear(4 * board_width * board_height, board_width * board_height)
        # 状态值层 state value layers
        self.val_conv1 = nn.Conv2d(128, 2, kernel_size=1)
        self.val_fc1 = nn.Linear(2 * board_width * board_height, 64)
        self.val_fc2 = nn.Linear(64, 1)

    def forward(self, state_input):
        # 通用层 common layers
        x = F.relu(self.conv1(state_input))
        x = F.relu(self.conv2(x))
        x = F.relu(self.conv3(x))
        # 行动策略层 action policy layers
        x_act = F.relu(self.act_conv1(x))
        x_act = x_act.view(-1, 4 * self.board_width * self.board_height)
        x_act = F.log_softmax(self.act_fc1(x_act))
        # 状态值层 state value layers
        x_val = F.relu(self.val_conv1(x))
        x_val = x_val.view(-1, 2 * self.board_width * self.board_height)
        x_val = F.relu(self.val_fc1(x_val))
        x_val = F.tanh(self.val_fc2(x_val))
        # 输出行动可能性 和 终局的预期状态值
        return x_act, x_val


class PolicyValueNet:
    def __init__(self, board_width, board_height, model_file=None, use_gpu=False):
        self.use_gpu = use_gpu
        self.board_width = board_width
        self.board_height = board_height
        self.l2_const = 1e-4  # L2正则项系数
        # 设置策略网络参数
        if self.use_gpu:
            self.policy_value_net = Net(board_width, board_height).cuda()
        else:
            self.policy_value_net = Net(board_width, board_height)
        self.optimizer = optim.Adam(self.policy_value_net.parameters(), weight_decay=self.l2_const)
        if model_file:
            net_params = torch.load(model_file)
            self.policy_value_net.load_state_dict(net_params)

    # 输入状态，得到行动的可能性和状态值，按照batch进行输入
    def policy_value(self, state_batch):
        if self.use_gpu:
            state_batch = Variable(torch.FloatTensor(state_batch).cuda())
            log_act_probs, value = self.policy_value_net(state_batch)
            # 通过e的次幂，求得action probabilities
            act_probs = np.exp(log_act_probs.data.cpu().numpy())
            return act_probs, value.data.cpu().numpy()
        else:
            state_batch = Variable(torch.FloatTensor(state_batch))
            log_act_probs, value = self.policy_value_net(state_batch)
            act_probs = np.exp(log_act_probs.data.numpy())
            return act_probs, value.data.numpy()

    # 相比于policy_value多了一个action位置，输入棋盘，输出所有可能的(action, probability)，以及棋盘状态分数[-1,1]
    def policy_value_fn(self, board):
        # 得到所有可以下棋的位置
        legal_positions = board.availables
        # ascontiguousarray函数将一个内存不连续存储的数组转换为内存连续存储的数组，使得运行速度更快
        current_state = np.ascontiguousarray(board.current_state().reshape(-1, 4, self.board_width, self.board_height))
        if self.use_gpu:
            # 前向传播，直接输入数据即可
            log_act_probs, value = self.policy_value_net(Variable(torch.from_numpy(current_state)).cuda().float())
            act_probs = np.exp(log_act_probs.data.cpu().numpy().flatten())
        else:
            log_act_probs, value = self.policy_value_net(Variable(torch.from_numpy(current_state)).float())
            act_probs = np.exp(log_act_probs.data.numpy().flatten())
        act_probs = zip(legal_positions, act_probs[legal_positions])
        value = value.data[0][0]
        # 返回 act_probs:所有可能的(action, probability)，value: 棋盘状态分数
        return act_probs, value

    # 训练一步
    def train_step(self, state_batch, mcts_probs, winner_batch, lr):
        # 包装变量
        if self.use_gpu:
            state_batch = Variable(torch.FloatTensor(state_batch).cuda())
            mcts_probs = Variable(torch.FloatTensor(mcts_probs).cuda())
            winner_batch = Variable(torch.FloatTensor(winner_batch).cuda())
        else:
            state_batch = Variable(torch.FloatTensor(state_batch))
            mcts_probs = Variable(torch.FloatTensor(mcts_probs))
            winner_batch = Variable(torch.FloatTensor(winner_batch))
        # 清空模型中参数的梯度，即梯度置为0
        self.optimizer.zero_grad()
        # 设置学习率
        for param_group in self.optimizer.param_groups:
            param_group['lr'] = lr
        # 前向传播
        log_act_probs, value = self.policy_value_net(state_batch)
        # 定义 loss = (z - v)^2 - pi^T * log(p) + c||theta||^2
        value_loss = F.mse_loss(value.view(-1), winner_batch)
        policy_loss = -torch.mean(torch.sum(mcts_probs * log_act_probs, 1))
        loss = value_loss + policy_loss
        # 反向传播，优化参数
        loss.backward()
        self.optimizer.step()
        # 计算Policy信息熵
        entropy = -torch.mean(torch.sum(torch.exp(log_act_probs) * log_act_probs, 1))
        # 返回loss和entropy
        return loss.item(), entropy.item()

    # 获得模型的参数，即state_dict
    def get_policy_param(self):
        net_params = self.policy_value_net.state_dict()
        return net_params

    # 保存模型文件
    def save_model(self, model_file):
        # 保存模型的参数
        net_params = self.get_policy_param()
        torch.save(net_params, model_file)


class TreeNode(object):
    # 节点初始化
    def __init__(self, parent, prior_p):
        self._parent = parent
        self._children = {}  # Action到TreeNode的映射map
        self._n_visits = 0  # 访问次数
        self._Q = 0  # 行动价值
        self._u = 0  # UCT值第二项，即调整后的访问次数（exploration）
        self._P = prior_p  # 先验概率

    # Expand，展开叶子节点（添加新的孩子节点）
    def expand(self, action_priors):
        for action, prob in action_priors:
            # 如果不是该节点的子节点，那么就expand 添加为子节点
            if action not in self._children:
                # 父亲节点为当前节点self,先验概率为prob
                self._children[action] = TreeNode(self, prob)

    # Select步骤，在孩子节点中，选择具有最大行动价值UCT，通过get_value(c_puct)函数得到
    def select(self, c_puct):
        # 每次选择最大UCT值的节点，返回(action, next_node)
        return max(self._children.items(), key=lambda act_node: act_node[1].get_value(c_puct))

    # 从叶子评估中，更新节点Q值和访问次数
    def update(self, leaf_value):
        # 节点访问次数+1
        self._n_visits += 1
        # 更新Q值，变化的Q=(leaf_value - self._Q) 对于所有访问次数进行平均
        self._Q += 1.0 * (leaf_value - self._Q) / self._n_visits

    # 递归的更新所有祖先，调用self.update
    def update_recursive(self, leaf_value):
        # 如果不是根节点，就需要先调用父亲节点的更新
        if self._parent:
            self._parent.update_recursive(-leaf_value)
        self.update(leaf_value)

    # 计算节点价值 UCT值 = Q值 + 调整后的访问次数（exploitation + exploration）
    def get_value(self, c_puct):
        # 计算调整后的访问次数
        self._u = (c_puct * self._P * np.sqrt(self._parent._n_visits) / (1 + self._n_visits))
        return self._Q + self._u

    # 判断是否为叶子节点
    def is_leaf(self):
        return self._children == {}

    # 判断是否为根节点
    def is_root(self):
        return self._parent is None


class MCTS(object):
    def __init__(self, policy_value_fn, c_puct=5, n_playout=10000):
        self._root = TreeNode(None, 1.0)  # 根节点
        self._policy = policy_value_fn  # 策略状态，考虑了棋盘状态，输出一组(action, probability)和分数[-1,1]之间
        self._c_puct = c_puct  # exploitation和exploration之间的折中系数
        self._n_playout = n_playout  # 模拟的次数

    def _playout(self, state):
        # 设置当前节点
        node = self._root
        # 必须要走到叶子节点
        while (1):
            if node.is_leaf():
                break
            # 基于贪心算法 选择下一步
            action, node = node.select(self._c_puct)
            state.do_move(action)
        # 对于current player，根据state 得到一组(action, probability) 和分数v [-1,1]之间（比赛结束时的预期结果）
        action_probs, leaf_value = self._policy(state)
        # 检查游戏是否结束
        end, winner = state.game_end()
        if not end:  # 没有结束，就展开节点
            node.expand(action_probs)
        else:
            # 游戏结束，计算leaf_value
            if winner == -1:  # 平均
                leaf_value = 0.0
            else:
                leaf_value = 1.0 if winner == state.get_current_player() else -1.0
            # 采用快速走子策略，评估叶子结点值（是否获胜）
            # leaf_value = self._evaluate_rollout(state)
        # 将子节点的评估值反向传播更新父节点(所有)
        node.update_recursive(-leaf_value)

    # 使用rollout策略，一直到游戏结束，如果当前选手获胜返回+1，对手获胜返回-1，平局返回0
    def _evaluate_rollout(self, state, limit=1000):
        player = state.get_current_player()
        for i in range(limit):
            end, winner = state.game_end()
            if end:
                break
            # 快速走子策略：随机走子
            action_probs = zip(state.availables, np.random.rand(len(state.availables)))
            max_action = max(action_probs, key=itemgetter(1))[0]
            state.do_move(max_action)
        else:
            # 如果没有break for循环，发出警告
            print("WARNING: rollout reached move limit")
        if winner == -1:  # 平局
            return 0
        else:
            return 1 if winner == player else -1

    # 顺序_n_playout次playout，返回可能的actions和相应的可能性
    # state为当前棋盘状态，temp 温度参数，控制了探索的程度 (0,1]范围
    # 当MCTS搜索完成时，返回局面state下的落子概率π，与N^(1 /temp)成正比，其中N是从根状态每次移动的访问计数，temp是控制温度的参数
    def get_move_probs(self, state, temp=1e-3):
        # 运行_n_playout次 _playout
        for n in range(self._n_playout):
            # 在进行_playout之前需要保存当前状态的副本，因为状态是就地修改的
            state_copy = copy.deepcopy(state)
            self._playout(state_copy)
        # 基于节点的访问次数，计算move probabilities
        act_visits = [(act, node._n_visits) for act, node in self._root._children.items()]
        acts, visits = zip(*act_visits)
        softmax = lambda x: np.exp(x - np.max(x)) / np.sum(np.exp(x - np.max(x)))
        act_probs = softmax(1.0 / temp * np.log(np.array(visits) + 1e-10))
        return acts, act_probs
        # 使用rollout策略，一直到游戏结束，如果当前选手获胜返回+1，对手获胜返回-1，平局返回0
        # 使用rollout策略，一直到游戏结束，如果当前选手获胜返回+1，对手获胜返回-1，平局返回0

    def _evaluate_rollout(self, state, limit=1000):
        player = state.get_current_player()
        for i in range(limit):
            end, winner = state.game_end()
            if end:
                break
            # 快速走子策略：随机走子
            action_probs = zip(state.availables, np.random.rand(len(state.availables)))
            max_action = max(action_probs, key=itemgetter(1))[0]
            state.do_move(max_action)
        else:
            # 如果没有break for循环，发出警告
            print("WARNING: rollout reached move limit")
        if winner == -1:  # 平局
            return 0
        else:
            return 1 if winner == player else -1

    def _evaluate_rollout(self, state, limit=1000):
        player = state.get_current_player()
        for i in range(limit):
            end, winner = state.game_end()
            if end:
                break
            # 快速走子策略：随机走子
            action_probs = zip(state.availables, np.random.rand(len(state.availables)))
            max_action = max(action_probs, key=itemgetter(1))[0]
            state.do_move(max_action)
        else:
            # 如果没有break for循环，发出警告
            print("WARNING: rollout reached move limit")
        if winner == -1:  # 平局
            return 0
        else:
            return 1 if winner == player else -1

    # 在树中前进一步
    def update_with_move(self, last_move):
        if last_move in self._root._children:
            self._root = self._root._children[last_move]
            self._root._parent = None
        else:
            self._root = TreeNode(None, 1.0)

    def __str__(self):
        return "MCTS"


class MCTSPlayer(object):
    def __init__(self, policy_value_function=None, c_puct=5, n_playout=2000, is_selfplay=0):
        # 使用MCTS进行搜索
        default_function = lambda board: zip(board.availables, np.ones(len(board.availables)) / len(board.availables)), 0
        policy_value_function = policy_value_function or default_function
        self.mcts = MCTS(policy_value_function, c_puct, n_playout)
        self._is_selfplay = is_selfplay

    # 设置player index
    def set_player_ind(self, p):
        self.player = p

    # 重置MCTS树
    def reset_player(self):
        self.mcts.update_with_move(-1)

    # 获取AI下棋的位置
    def get_action(self, board, temp=1e-3, return_prob=0):
        # 获取所有可能的下棋位置
        sensible_moves = board.availables
        # MCTS返回的pi向量，基于alphaGo Zero论文
        move_probs = np.zeros(board.width * board.height)
        if len(sensible_moves) > 0:
            acts, probs = self.mcts.get_move_probs(board, temp)
            move_probs[list(acts)] = probs
            if self._is_selfplay:
                # 为探索添加Dirichlet噪声(需要进行自我训练)
                move = np.random.choice(acts, p=0.75 * probs + 0.25 * np.random.dirichlet(0.3 * np.ones(len(probs))))
                # 更新根节点，重新使用搜索树
                self.mcts.update_with_move(move)
            else:
                # 默认temp=1e-3, 几乎等同于选择概率最大的那一步
                move = np.random.choice(acts, p=probs)
                # 重置根节点 reset the root node
                self.mcts.update_with_move(-1)
            #                location = board.move_to_location(move)
            #                print("AI move: %d,%d\n" % (location[0], location[1]))
            if return_prob:
                return move, move_probs
            else:
                return move
        else:
            print("WARNING: the board is full")

    def __str__(self):
        return "MCTS {}".format(self.player)


class Board(object):
    def __init__(self, **kwargs):
        # 默认宽度、高度为8
        self.width = int(kwargs.get('width', 8))
        self.height = int(kwargs.get('height', 8))
        # 保存棋盘状态，为字典结构 key为棋盘位置move，value为player编号
        self.states = {}
        # 设置 n子棋，默认为5
        self.n_in_row = int(kwargs.get('n_in_row', 5))
        self.players = [1, 2]  # player1 and player2

    # 初始化棋盘，n_in_row子棋
    def init_board(self, start_player=0):
        if self.width < self.n_in_row or self.height < self.n_in_row:
            raise Exception('board width and height can not be less than {}'.format(self.n_in_row))
        # 初始化current_player，设置为start player
        self.current_player = self.players[start_player]  
        # 保存棋盘中可以下棋的位置 list类型
        self.availables = list(range(self.width * self.height))
        self.states = {}
        self.last_move = -1

    # 通过move，返回location:h,w
    def move_to_location(self, move):
        h = move // self.width
        w = move % self.width
        return [h, w]

    # 输入location二维数组h,w，返回move
    def location_to_move(self, location):
        if len(location) != 2:
            return -1
        h = location[0]
        w = location[1]
        move = h * self.width + w
        if move not in range(self.width * self.height):
            return -1
        return move

    # 返回当前用户的棋盘状态，状态大小为4*width*height
    def current_state(self):
        square_state = np.zeros((4, self.width, self.height))
        if self.states:
            # 获取每一步，以及下棋的player
            moves, players = np.array(list(zip(*self.states.items())))
            move_curr = moves[players == self.current_player]
            move_oppo = moves[players != self.current_player]
            # 当前player状态
            square_state[0][move_curr // self.width, move_curr % self.height] = 1.0
            # 对手player状态
            square_state[1][move_oppo // self.width, move_oppo % self.height] = 1.0
            # 记录最后一步（落子）的位置
            square_state[2][self.last_move // self.width, self.last_move % self.height] = 1.0
        if len(self.states) % 2 == 0:
            square_state[3][:, :] = 1.0  # 显示的颜色值 
        return square_state[:, ::-1, :]

    # 当前current_player下了一步棋，需要保存状态，执棋方切换
    def do_move(self, move):
        # 保存当前move 是由current_player下的
        self.states[move] = self.current_player
        # 下了一步棋，棋盘中可以下的位置就少了一个
        self.availables.remove(move)
        # 执棋方切换
        self.current_player = self.players[0] if self.current_player == self.players[1] else self.players[1]
        self.last_move = move

    # 判断是否有人获胜
    def has_a_winner(self):
        width = self.width
        height = self.height
        states = self.states
        n = self.n_in_row
        moved = list(set(range(width * height)) - set(self.availables))
        # 单方下棋步骤不足n_in_row
        if len(moved) < self.n_in_row *2-1:
            return False, -1
        for m in moved:
            # 将move转化为 [h,w]
            h = m // width
            w = m % width
            # 当前步是由哪个player下的
            player = states[m]
            if (w in range(width - n + 1) and len(set(states.get(i, -1) for i in range(m, m + n))) == 1):
                return True, player
            if (h in range(height - n + 1) and len(set(states.get(i, -1) for i in range(m, m + n * width, width))) == 1):
                return True, player
            if (w in range(width - n + 1) and h in range(height - n + 1) and len(set(states.get(i, -1) for i in range(m, m + n * (width + 1), width + 1))) == 1):
                return True, player
            if (w in range(n - 1, width) and h in range(height - n + 1) and len(set(states.get(i, -1) for i in range(m, m + n * (width - 1), width - 1))) == 1):
                return True, player
        return False, -1

    # 判断游戏是否结束
    def game_end(self):
        win, winner = self.has_a_winner()
        if win:
            return True, winner
        elif not len(self.availables):
            return True, -1
        return False, -1

    def get_current_player(self):
        return self.current_player


class Game(object):
    def __init__(self, board, **kwargs):
        self.board = board

    # 绘制棋盘和棋子信息
    def graphic(self, board, player1, player2):
        width = board.width
        height = board.height
        print("Player", player1, "with X".rjust(3))
        print("Player", player2, "with O".rjust(3))
        print()
        for x in range(width):
            print("{0:8}".format(x), end='')
        print('\r\n')
        for i in range(height - 1, -1, -1):
            print("{0:4d}".format(i), end='')
            for j in range(width):
                loc = i * width + j
                p = board.states.get(loc, -1)
                if p == player1:
                    print('X'.center(8), end='')
                elif p == player2:
                    print('O'.center(8), end='')
                else:
                    print('_'.center(8), end='')
            print('\r\n\r\n')

    # 开始比赛，player1与player2
    def start_play(self, player1, player2, start_player=0, is_shown=1):
        if start_player not in (0, 1):
            raise Exception('start_player should be either 0 (player1 first) or 1 (player2 first)')
        # 初始化棋盘
        self.board.init_board(start_player)
        p1, p2 = self.board.players
        # 设置player index
        player1.set_player_ind(p1)
        player2.set_player_ind(p2)
        players = {p1: player1, p2: player2}
        if is_shown:
            self.graphic(self.board, player1.player, player2.player)
        # 一直循环到比赛结束    
        while True:
            # 获取当前的player
            current_player = self.board.get_current_player()
            player_in_turn = players[current_player]
            move = player_in_turn.get_action(self.board)
            self.board.do_move(move)
            if is_shown:
                self.graphic(self.board, player1.player, player2.player)
            end, winner = self.board.game_end()
            if end:
                if is_shown:
                    if winner != -1:
                        print("游戏结束，获胜方为 ", players[winner])
                    else:
                        print("游戏结束，双方平局")
                return winner

    # AI自我对弈，存储自我对弈数据 用于训练 self-play data: (state, mcts_probs, z)
    def start_self_play(self, player, is_shown=0, temp=1e-3):
        # 初始化棋盘
        self.board.init_board()
        p1, p2 = self.board.players
        # 记录该局对应的数据：states, mcts_probs, current_players
        states, mcts_probs, current_players = [], [], []
        # 一直循环到比赛结束
        while True:
            # 得到player的下棋位置
            move, move_probs = player.get_action(self.board, temp=temp, return_prob=1)
            # 存储数据
            states.append(self.board.current_state())  # 棋盘状态
            mcts_probs.append(move_probs)
            current_players.append(self.board.current_player)
            # 按照move来下棋
            self.board.do_move(move)
            if is_shown:
                self.graphic(self.board, p1, p2)
            # 判断游戏是否结束end，统计获胜方 winner
            end, winner = self.board.game_end()
            if end:
                # 记录该局对弈中的每步分值，胜1，负-1，平局0
                winners_z = np.zeros(len(current_players))
                if winner != -1:
                    winners_z[np.array(current_players) == winner] = 1.0
                    winners_z[np.array(current_players) != winner] = -1.0
                # 重置MCTS根节点 reset MCTS root node
                player.reset_player()
                if is_shown:
                    if winner != -1:
                        print("游戏结束，获胜一方为 ", winner)
                    else:
                        print("游戏结束，双方平局")
                # 返回获胜方，self-play数据: (state, mcts_probs, z)
                return winner, zip(states, mcts_probs, winners_z)


class Human(object):
    def __init__(self):
        self.player = None

    def set_player_ind(self, p):
        self.player = p

    # 通过input交互，得到用户的下棋位置 move
    def get_action(self, board):
        try:
            location = input("输入你下棋的位置 x,y: ")
            print(location)
            if isinstance(location, str):  # for python3
                location = [int(n, 10) for n in location.split(",")]
            move = board.location_to_move(location)
        except Exception as e:
            move = -1
        if move == -1 or move not in board.availables:
            print("输入位置非法")
            move = self.get_action(board)
        return move

    def __str__(self):
        return "Human {}".format(self.player)


class TrainPipeline:
    def __init__(self, init_model=None):
        # 设置棋盘和游戏的参数
        self.board_width = 6
        self.board_height = 6
        self.n_in_row = 4
        self.board = Board(width=self.board_width, height=self.board_height, n_in_row=self.n_in_row)
        self.game = Game(self.board)
        # 设置训练参数
        self.learn_rate = 2e-3  # 基准学习率
        self.lr_multiplier = 1.0  # 基于KL自动调整学习倍速
        self.temp = 1.0  # 温度参数
        self.n_playout = 400  # 每下一步棋，模拟的步骤数
        self.c_puct = 5  # exploitation和exploration之间的折中系数
        self.buffer_size = 10000
        self.batch_size = 512  # mini-batch size for training
        self.data_buffer = deque(maxlen=self.buffer_size)  # 使用 deque 创建一个双端队列
        self.play_batch_size = 1
        self.epochs = 5  # num of train_steps for each update
        self.kl_targ = 0.02  # 早停检查
        self.check_freq = 50  # 每50次检查一次，策略价值网络是否更新
        self.game_batch_num = 500  # 训练多少个epoch
        self.best_win_ratio = 0.0  # 当前最佳胜率，用他来判断是否有更好的模型
        # 弱AI（纯MCTS）模拟步数，用于给训练的策略AI提供对手
        self.pure_mcts_playout_num = 1000
        if init_model:
            # 通过init_model设置策略网络
            self.policy_value_net = PolicyValueNet(self.board_width, self.board_height, model_file=init_model)
        else:
            # 训练一个新的策略网络
            self.policy_value_net = PolicyValueNet(self.board_width, self.board_height)
        # AI Player，设置is_selfplay=1 自我对弈，因为是在进行训练
        self.mcts_player = MCTSPlayer(self.policy_value_net.policy_value_fn, c_puct=self.c_puct, n_playout=self.n_playout, is_selfplay=1)

    # 通过旋转和翻转增加数据集, play_data: [(state, mcts_prob, winner_z), ..., ...]
    def get_equi_data(self, play_data):
        extend_data = []
        for state, mcts_porb, winner in play_data:
            # 在4个方向上进行expand，每个方向都进行旋转，水平翻转
            for i in [1, 2, 3, 4]:
                # 逆时针旋转
                equi_state = np.array([np.rot90(s, i) for s in state])
                equi_mcts_prob = np.rot90(np.flipud(mcts_porb.reshape(self.board_height, self.board_width)), i)
                extend_data.append((equi_state, np.flipud(equi_mcts_prob).flatten(), winner))
                # 水平翻转
                equi_state = np.array([np.fliplr(s) for s in equi_state])
                equi_mcts_prob = np.fliplr(equi_mcts_prob)
                extend_data.append((equi_state, np.flipud(equi_mcts_prob).flatten(), winner))
        return extend_data

    # 收集自我对弈数据，用于训练
    def collect_selfplay_data(self, n_games=1):
        for i in range(n_games):
            # 与MCTS Player进行对弈
            winner, play_data = self.game.start_self_play(self.mcts_player, temp=self.temp)
            play_data = list(play_data)[:]
            # 保存下了多少步
            self.episode_len = len(play_data)
            # 增加数据 play_data
            play_data = self.get_equi_data(play_data)
            self.data_buffer.extend(play_data)

    # 更新策略网络
    def policy_update(self):
        mini_batch = random.sample(self.data_buffer, self.batch_size)
        state_batch = [data[0] for data in mini_batch]
        mcts_probs_batch = [data[1] for data in mini_batch]
        winner_batch = [data[2] for data in mini_batch]
        # 保存更新前的old_probs, old_v
        old_probs, old_v = self.policy_value_net.policy_value(state_batch)
        for i in range(self.epochs):
            # 每次训练，调整参数，返回loss和entropy
            loss, entropy = self.policy_value_net.train_step(state_batch, mcts_probs_batch, winner_batch,
                self.learn_rate * self.lr_multiplier)
            # 输入状态，得到行动的可能性和状态值，按照batch进行输入
            new_probs, new_v = self.policy_value_net.policy_value(state_batch)
            # 计算更新前后两次的loss差
            kl = np.mean(np.sum(old_probs * (np.log(old_probs + 1e-10) - np.log(new_probs + 1e-10)), axis=1))
            if kl > self.kl_targ * 4:  # early stopping if D_KL diverges badly
                break
        # 动态调整学习倍率 lr_multiplier
        if kl > self.kl_targ * 2 and self.lr_multiplier > 0.1:
            self.lr_multiplier /= 1.5
        elif kl < self.kl_targ / 2 and self.lr_multiplier < 10:
            self.lr_multiplier *= 1.5
        explained_var_old = (1 - np.var(np.array(winner_batch) - old_v.flatten()) / np.var(np.array(winner_batch)))
        explained_var_new = (1 - np.var(np.array(winner_batch) - new_v.flatten()) / np.var(np.array(winner_batch)))
        s = "kl:{:.5f},lr_multiplier:{:.3f},loss:{},entropy:{},explained_var_old:{:.3f},explained_var_new:{:.3f}"
        print(s.format(kl, self.lr_multiplier, loss, entropy, explained_var_old, explained_var_new))
        return loss, entropy

    # 用于评估训练网络的质量，评估一共10场play，返回比赛胜率（赢1分、输0分、平0.5分）
    def policy_evaluate(self, n_games=10):
        current_mcts_player = MCTSPlayer(self.policy_value_net.policy_value_fn, c_puct=self.c_puct, n_playout=self.n_playout)
        pure_mcts_player = MCTSPlayer(c_puct=5, n_playout=self.pure_mcts_playout_num)
        win_cnt = defaultdict(int)
        for i in range(n_games):
            # AI和弱AI（纯MCTS）对弈，不需要可视化 is_shown=0，双方轮流职黑 start_player=i % 2
            winner = self.game.start_play(current_mcts_player, pure_mcts_player, start_player=i % 2, is_shown=0)
            win_cnt[winner] += 1
        # 计算胜率，平手计为0.5分
        win_ratio = 1.0 * (win_cnt[1] + 0.5 * win_cnt[-1]) / n_games
        print("num_playouts:{}, win: {}, lose: {}, tie:{}".format(self.pure_mcts_playout_num, win_cnt[1], win_cnt[2], win_cnt[-1]))
        return win_ratio

    def run(self):
        # 开始训练
        try:
            # 训练game_batch_num次，每个batch比赛play_batch_size场
            for i in range(self.game_batch_num):
                # 收集自我对弈数据
                self.collect_selfplay_data(self.play_batch_size)
                print("batch i:{}, episode_len:{}".format(i + 1, self.episode_len))
                if len(self.data_buffer) > self.batch_size:
                    loss, entropy = self.policy_update()
                # 判断当前模型的表现，保存最优模型
                if (i + 1) % self.check_freq == 0:
                    print("current self-play batch: {}".format(i + 1))
                    win_ratio = self.policy_evaluate()
                    # 保存当前策略
                    self.policy_value_net.save_model('./current_policy.model')
                    if win_ratio > self.best_win_ratio:
                        print("发现新的最优策略，进行策略更新")
                        self.best_win_ratio = win_ratio
                        # 更新最优策略
                        self.policy_value_net.save_model('./best_policy.model')
                        if (self.best_win_ratio == 1.0 and self.pure_mcts_playout_num < 5000):
                            self.pure_mcts_playout_num += 1000
                            self.best_win_ratio = 0.0
        except KeyboardInterrupt:
            print('\n\rquit')


def run():
    n = 5
    # 这里可以修改棋盘的大小，需要和AI Model的棋盘大小相等
    width, height = 6, 6
    # 调用AI模型
    model_file = 'best_policy.model'
    try:
        # 初始化棋盘
        board = Board(width=width, height=height, n_in_row=n)
        game = Game(board)
        # ############### human VS AI ###################
        # 加载AI Model
        best_policy = PolicyValueNet(width, height, model_file = model_file, use_gpu=True)
        # 设置n_playout越大，效果越好，不需要设置is_selfplay，因为不需要进行AI训练
        mcts_player = MCTSPlayer(best_policy.policy_value_fn, c_puct=5, n_playout=400)
        # 创建人类player, 输入下棋位置比如 3,3
        human = Human()
        # start_player=1表示电脑先手，0表示人先手
        game.start_play(human, mcts_player, start_player=1, is_shown=1)
    except KeyboardInterrupt:
        print('\n\rquit')


if __name__ == '__main__':
    training_pipeline = TrainPipeline()
    training_pipeline.run()
