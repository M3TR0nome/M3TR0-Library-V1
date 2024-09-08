mport "@stdlib/deploy";
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

    followers: map<Int, Follower>;

    init() {
        self.l = 0;
        self.root = newAddress(0,0);
        self.admins = emptyMap(); 
        self.users = emptyMap();
        self.uids = emptyMap();
        self.followers = emptyMap();
        self._setRoot(sender());
        self._log(self.root,"Root Initialisation !",self.l);
        self.l += 1;
    }

}
