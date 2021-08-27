import http from 'http';
import express from 'express';
import router from './routes';
import plugin from "./plugin";

const app = express();
plugin.beforeRouter(app)
router(app);
plugin.afterRouter(app)
let server = http.createServer(app);
plugin.socket(server)
server.on('listening', () => {
	const addr = server.address();
	console.log(`Listening on ${addr.address}:${addr.port}`);
});
server.on('error', (error) => {
	const msg = error.code === 'EADDRINUSE' ? `${port} used` : error.code === 'EADDRINUSE' ? 'require admin' : ''
	if (msg) {
		console.error(msg)
	} else {
		throw error
	}
	process.exit(1);
});
server.listen(parseInt(process.env.PORT) || 8001);
