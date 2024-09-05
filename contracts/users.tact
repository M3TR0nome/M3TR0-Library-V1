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

    receive(msg:NewAccount) {
        let jc: Account = self.users.get(sender())!!;
        
            let sc: Score = Score {
                community: 0,
                liquidity: 0,
                activity: 0
            };
            let acc: Account = Account {
                adr: sender(),
                handle: msg.handle,
                status: msg.status,
                avatar: msg.avatar,
                joined: now(),
                score: sc
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
                score: sc
            };
        self.users.set(sender(),acc);
    }

    receive(msg:DeleteAccount) {
        let jc: Account = self.users.get(sender())!!;
        if(msg.permanent == true) {
            jc.joined = emptyMap();
        }
        let acc: Account = Account {
                adr: sender(),
                handle: "",
                status: "",
                avatar: "",
                joined: jc.joined,
                score: jc.score
            };
    }

    get fun showUsers(): map<Address, Account> {
        return self.users;
    }

    get fun showAccountByAdr(adr: Address): Account {
        return self.users.get(adr)!!;
    }

}
