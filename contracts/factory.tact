import "@stdlib/deploy";
import "./admins.tact";
import "./logs.tact";
import "./freinds.tact";


contract Factory with Deployable, Administratable, Loggable, Relatable {

    // Administratable required Vars
    root: Address;
    admins: map<Address, Admin>;

    // Loggable required Vars
    logs: map<Int, Log>;
    l:Int as uint64;

    // Accountable required Vars
    users: map<Address, Account>;
    uids: map<Int,Bool>;

    follow: map<Int, Follower>;
    fid: map<Address,Int>;


    init() {
        self.l = 0;
        self.root = newAddress(0,0);
        self.admins = emptyMap(); 
        self.users = emptyMap();
        self.uids = emptyMap();
        self.follow = emptyMap();
        self.fid = emptyMap();
        self._setRoot(sender());
        self._log(self.root,"Root Initialisation !",self.l);
        self.l += 1;
    }

    receive(msg: Follow) {
        let acc: Account = self._getAccountByAdr(sender());
        let old: Follower = self.follow.get(acc.uid)!!;
        old.following.set(self.fid.get(sender())!!,msg.freind);
        self.follow.set(self.fid.get(sender())!!,old); 
        let u: Int = self.fid.get(sender())!!;
        self.fid.set(sender(), u + 1);
    }

}
