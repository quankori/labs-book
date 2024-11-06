process.on('message', (message) => {
    if (message.task === 'calculate') {
        const result = message.number * 2; // Just an example operation
        process.send({ result });
    }
});