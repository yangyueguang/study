'use strict';
import express from 'express';
import { checkAdmin } from './plugin'
import { login, logout, list, remove } from './service/server'
const routerA = express.Router();
routerA.post('/signup', checkAdmin, logout);
routerA.get('/login', login);

const routerB = express.Router();
routerB.get('/list', list);
routerB.post('/remove', remove);

export default app => {
    app.use('/api', routerA);
    app.use('/user', routerB);
}
