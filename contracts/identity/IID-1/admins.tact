import "@stdlib/deploy";


struct Admin {
    adr: Address;
    editAdmins: Bool;
    editUsers: Bool;
    editContent: Bool;
    editPrivacy: Bool;
    editSettings: Bool;
    editFinTech: Bool;
    editContracts: Bool;
    selfDestroy: Bool;
}

message NewAdmin {
    adr: Address;
    go: Bool;
}

message EditAdmin {
    adr: Address;
    editAdmins: Bool;
    editUsers: Bool;
    editContent: Bool;
    editPrivacy: Bool;
    editSettings: Bool;
    editFinTech: Bool;
    editContracts: Bool;
    selfDestroy: Bool;
}

message DeleteAdmin {
    adr: Address;
}

trait Administratable {

    root: Address;
    admins: map<Address, Admin>;

    receive(msg: NewAdmin) {
        let ad: Admin = self.admins.get(sender())!!;
        if(ad.editAdmins == true){
            let adm: Admin = self.admins.get(msg.adr)!!;
            if(adm.adr != sender()) {
                let admin: Admin = Admin {
                adr: sender(),
                editAdmins: msg.go,
                editUsers: false,
                editContent: true,
                editPrivacy: false,
                editSettings: true,
                editFinTech: msg.go,
                editContracts: msg.go,
                selfDestroy: false,
                };
                self.admins.set(msg.adr,admin);
                self.reply("You'll be Admin !".asComment());
            }
            else {
                self.reply("Already Admin ! Don't waste GAS on TX !".asComment());
            }
        }
    }

    receive(msg: EditAdmin) {
        let adm: Admin = self.admins.get(sender())!!;
        if(adm.editAdmins == true) {
            let admin: Admin = Admin {
            adr: msg.adr,
            editAdmins: false,
            editUsers: false,
            editContent: true,
            editPrivacy: false,
            editSettings: true,
            editFinTech: true,
            editContracts: true,
            selfDestroy: false,
            };
            self.admins.set(msg.adr,admin);
            self.reply("You'll be a whole new Admin !".asComment());
        }
        else {
            self.reply("Already Admin ! Don't waste GAS on TX !".asComment());
        }
    }

    receive(msg: DeleteAdmin) {
        if(sender() != self.root){
            let user: Admin = self.admins.get(sender())!!;
            if(user.editAdmins == true) {
                self.admins.set(sender(),emptyMap());
                self.reply("One of us has left !".asComment());
            }
            else {
                self.reply("You're not priveledged to delete Admins !".asComment());
            }
        }
        else {
                self.reply("You're too neccessary to let you go !".asComment());
            }
    }

    fun _setRoot(adr: Address): Bool {
        let root: Admin = Admin {
            adr: adr,
            editAdmins: true,
            editUsers: true,
            editContent: true,
            editPrivacy: true,
            editSettings: true,
            editFinTech: true,
            editContracts: true,
            selfDestroy: true,
        };
        self.admins.set(adr,root);
        self.root = adr;
        return true;
    }

    get fun showAdmins():map<Address, Admin> {
        return self.admins;
    } 

    get fun showAdmin(adr: Address): Admin {
        return self.admins.get(adr)!!;
    }

}
