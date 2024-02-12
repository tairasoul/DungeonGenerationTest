import remotes from "shared/remotes";

remotes.serverLog.connect((str, logType) => {
    switch (logType) {
        case "Warning":
            warn(`[Server]: ${str}`);
            break;
        case "Error":
            error(`[Server]: ${str}`, 0);
            break;
        case "Message":
            print(`[Server]: ${str}`);
            break;
    }
})