import "./users.tact";

struct Follower {
    id: Int as uint64;
    follower: Address;
    following: Address;
}

message Follow {
    freind: Address;
}

trait Relatable with Accountable {

        // Accountable required Vars
    users: map<Address, Account>;
    uids: map<Int,Bool>;

    followers: map<Int, Follower>;
    // r: Int as uint64;

}
