struct Score {
    community: Int as uint64;
    liquidity: Int as uint64;
    activity: Int as uint64;
}

struct Account {
    adr: Address;
    handle: String;
    status: String;
    avatar: String;
    joined: Int? = null;
    score: Score;
    uid: Int as uint256;
}

message NewAccount {
    handle: String;
    status: String;
    avatar: String;
}

message EditAccount {
    handle: String;
    status: String;
    avatar: String;
    com: Int;
    liq: Int;
    act: Int;
}

message DeleteAccount {
    adr: Address;
    permanent: Bool;
}


trait Accountable {

    users: map<Address, Account>;
    uids: map<Int, Bool>;

    receive(msg:NewAccount) {
        let jc: Account = self.users.get(sender())!!;
        
            let sc: Score = Score {
                community: 0,
                liquidity: 0,
                activity: 0
            };
            let uid: Int = random(100000,999999);
            /*while(self.uids.get(uid) != false) {
                uid = random(100000,999999);
            }*/
            let acc: Account = Account {
                adr: sender(),
                handle: msg.handle,
                status: msg.status,
                avatar: msg.avatar,
                joined: now(),
                score: sc,
                uid: uid
            };

        self.users.set(sender(),acc);
    }

    receive(msg:EditAccount) {
        let jc: Account = self.users.get(sender())!!;
        
            let sc: Score = Score {
                community: msg.com,
                liquidity: msg.liq,
                activity: msg.act
            };
            let acc: Account = Account {
                adr: jc.adr,
                handle: msg.handle,
                status: msg.status,
                avatar: msg.avatar,
                joined: jc.joined,
                score: sc,
                uid: jc.uid
            };
        self.users.set(sender(),acc);
    }

    receive(msg:DeleteAccount) {
        let jc: Account = self.users.get(sender())!!;
        if(msg.permanent == true) {
            jc.joined = 0;
            let sc: Score = Score {
                community: 0,
                liquidity: 0,
                activity: 0
            };
            jc.score = sc;
        }
        let acc: Account = Account {
                adr: sender(),
                handle: "",
                status: "",
                avatar: "",
                joined: jc.joined,
                score: jc.score,
                uid: jc.uid
            };
        self.users.set(sender(),acc);
    }

    get fun showUsers(): map<Address, Account> {
        return self.users;
    }

    get fun showAccountByAdr(adr: Address): Account {
        return self._getAccountByAdr(adr);
    }

    fun _getAccountByAdr(adr: Address): Account {
        return self.users.get(adr)!!;
    }

}
