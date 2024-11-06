const { fork } = require('child_process');

// Create a child process
const child = fork('child.js'); // Assumes there's a separate "child.js" script

// Send data to child process
child.send({ task: 'calculate', number: 10 });

// Receive data from child process
child.on('message', (message) => {
    console.log('Received from child:', message);
});