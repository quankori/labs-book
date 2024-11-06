const {
  Worker,
  isMainThread,
  parentPort,
  workerData,
} = require("worker_threads");

if (isMainThread) {
  // Main thread code
  const worker = new Worker(__filename, { workerData: { number: 10 } });
  worker.on("message", (result) => {
    console.log("Result from worker:", result);
  });
} else {
  // Worker thread code
  const result = workerData.number * 2;
  parentPort.postMessage(result);
}
