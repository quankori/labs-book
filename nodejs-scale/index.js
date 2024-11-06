// Child Processes: Suitable for isolated, parallel tasks without shared memory.
// Worker Threads: Ideal for CPU-intensive tasks with shared memory access.

const os = require('os');
const numCPUs = os.cpus().length;
console.log(`Number of CPU cores: ${numCPUs}`);
