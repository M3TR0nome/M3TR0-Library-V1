import "@stdlib/deploy";


struct Log {
    id: Int as uint64;
    date: Int as uint64;
    action: String;
    actor: Address;
}

trait Loggable {

    logs: map<Int, Log>;

    fun _log(adr: Address, act: String, i: Int): Log {
        let log: Log = Log {
            id: i,
            date: now(),
            action: act,
            actor: adr
        }; 
        self.logs.set(i,log);
        return log;
    }

    get fun showLogs(): map<Int, Log> {
        return self.logs;
    } 

    get fun showLog(id: Int): Log {
        return self.logs.get(id)!!;
    }

}
