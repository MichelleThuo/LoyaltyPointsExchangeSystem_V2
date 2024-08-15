import Debug "mo:base/Debug";

actor LoyaltyExchange {

    // Persistent storage of users in a map
    stable var users : Trie.Trie<Text, User> = Trie.empty();

    // Define the two types of points
    type BongaPoints = Nat;
    type NaivasLoyaltyPoints = Nat;

    // Define a User with a balance of each type of points
    type User = {
        id: Text;
        bongaPoints: BongaPoints;
        naivasLoyaltyPoints: NaivasLoyaltyPoints;
    };

    // Initialize two users
    users.put("User1", { id = "User1"; bongaPoints = 1000; naivasLoyaltyPoints = 500 });
    users.put("User2", { id = "User2"; bongaPoints = 750; naivasLoyaltyPoints = 1200 });

    // Function to transfer BongaPoints between users
    public func transferBongaPoints(fromId: Text, toId: Text, amount: BongaPoints): async () {
        switch (users.get(fromId)) {
            case (?fromUser) {
                if (fromUser.bongaPoints >= amount) {
                    switch (users.get(toId)) {
                        case (?toUser) {
                            users.put(fromId, { fromUser with bongaPoints = fromUser.bongaPoints - amount });
                            users.put(toId, { toUser with bongaPoints = toUser.bongaPoints + amount });
                            Debug.print("BongaPoints Transfer Successful");
                        };
                    };
                } else {
                    Debug.print("Insufficient BongaPoints");
                };
            };
        };
    };

    // Function to transfer NaivasLoyaltyPoints between users
    public func transferNaivasLoyaltyPoints(fromId: Text, toId: Text, amount: NaivasLoyaltyPoints): async () {
        switch (users.get(fromId)) {
            case (?fromUser) {
                if (fromUser.naivasLoyaltyPoints >= amount) {
                    switch (users.get(toId)) {
                        case (?toUser) {
                            users.put(fromId, { fromUser with naivasLoyaltyPoints = fromUser.naivasLoyaltyPoints - amount });
                            users.put(toId, { toUser with naivasLoyaltyPoints = toUser.naivasLoyaltyPoints + amount });
                            Debug.print("NaivasLoyaltyPoints Transfer Successful");
                        };
                    };
                } else {
                    Debug.print("Insufficient NaivasLoyaltyPoints");
                };
            };
        };
    };

    // Function to retrieve a user's point balances
    public func getUser(id: Text): async ?User {
        return users.get(id);
    };
}
