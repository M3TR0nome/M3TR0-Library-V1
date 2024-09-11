import "./users.tact";

struct Follower {
    uid: Int as uint256;
    follower: Address;
    following: map<Int, Address>;
}

message Follow {
    freind: Address;
}

trait Relatable with Accountable {

        // Accountable required Vars
    users: map<Address, Account>;
    uids: map<Int,Bool>;

    follow: map<Int, Follower>;

    get fun showFreindsByAdr(adr: Address): Follower {
        let acc: Account = self._getAccountByAdr(adr);
        return self.follow.get(acc.uid)!!;
    }
}
