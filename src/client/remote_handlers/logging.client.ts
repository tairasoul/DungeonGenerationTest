import remotes from "shared/remotes";

remotes.serverLog.connect((str, filePath, lineNumber, logType) => {
    switch (logType) {
        case "Warning":
            warn(`[${filePath}:${lineNumber}]: ${str}`);
            break;
        case "Error":
            error(`[${filePath}:${lineNumber}]: ${str}`, 0);
            break;
        case "Message":
            print(`[${filePath}:${lineNumber}]: ${str}`);
            break;
    }
})