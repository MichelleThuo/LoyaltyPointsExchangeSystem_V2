import Nat "mo:base/Nat";

actor LoyaltyPoints {
    // Stores the points for each user
    var userPoints : TrieMap.Text<Nat> = TrieMap.Text<Nat>();

    // Function to add points to a user
    public func addPoints(userId: Text, points: Nat) : async Text {
        let currentPoints = switch (userPoints.get(userId)) {
            case (null) { 0 };
            case (?value) { value };
        };
        let newPoints = currentPoints + points;
        userPoints.put(userId, newPoints);
        return "Points added successfully";
    };

    // Function to spend points from a user
    public func spendPoints(userId: Text, points: Nat) : async Text {
        let currentPoints = switch (userPoints.get(userId)) {
            case (null) { 0 };
            case (?value) { value };
        };
        if (currentPoints < points) {
            return "Insufficient points";
        } else {
            let newPoints = currentPoints - points;
            userPoints.put(userId, newPoints);
            return "Points spent successfully";
        };
    };

    // Function to check points of a user
    public func checkPoints(userId: Text) : async Nat {
        switch (userPoints.get(userId)) {
            case (null) { 0 };
            case (?value) { value };
        }
    };
};
