import Debug "mo:base/Debug";
import Trie "mo:base/Trie";

// Comparison function for Text keys
func textCompare(a: Text, b: Text): Bool {
    return a == b;
}

// Define the two types of points
type BongaPoints = Nat;
type NaivasLoyaltyPoints = Nat;

// Define a User with a balance of each type of points
type User = {
    id: Text;
    bongaPoints: BongaPoints;
    naivasLoyaltyPoints: NaivasLoyaltyPoints;
};

actor LoyaltyExchange {

    // Persistent storage of users in a Trie map
    stable var users : Trie.Trie<Text, User> = Trie.empty(textCompare);

    // Initialize two users
    public func initializeUsers() : async () {
        users := Trie.put(users, "User1", { id = "User1"; bongaPoints = 1000; naivasLoyaltyPoints = 500 }, textCompare);
        users := Trie.put(users, "User2", { id = "User2"; bongaPoints = 750; naivasLoyaltyPoints = 1200 }, textCompare);
    };

    // Function to transfer BongaPoints between users
    public func transferBongaPoints(fromId: Text, toId: Text, amount: BongaPoints): async () {
        switch (Trie.find(users, fromId, textCompare)) {
            case (?fromUser) {
                if (fromUser.bongaPoints >= amount) {
                    switch (Trie.find(users, toId, textCompare)) {
                        case (?toUser) {
                            users := Trie.put(users, fromId, { fromUser with bongaPoints = fromUser.bongaPoints - amount }, textCompare);
                            users := Trie.put(users, toId, { toUser with bongaPoints = toUser.bongaPoints + amount }, textCompare);
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
        switch (Trie.find(users, fromId, textCompare)) {
            case (?fromUser) {
                if (fromUser.naivasLoyaltyPoints >= amount) {
                    switch (Trie.find(users, toId, textCompare)) {
                        case (?toUser) {
                            users := Trie.put(users, fromId, { fromUser with naivasLoyaltyPoints = fromUser.naivasLoyaltyPoints - amount }, textCompare);
                            users := Trie.put(users, toId, { toUser with naivasLoyaltyPoints = toUser.naivasLoyaltyPoints + amount }, textCompare);
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
        return Trie.find(users, id, textCompare);
    };
}
