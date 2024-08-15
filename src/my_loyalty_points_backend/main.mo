actor LoyaltyPoints {
    var points : [(principal, (nat64, nat64))] = [
        (principal "user1", (1000, 500)),
        (principal "user2", (800, 700))
    ];

    public func issueBongaPoints(to : principal, amount : nat64) : async Result<(), Text> {
        let index = indexOf(points, to);
        if (index == null) {
            points := Array.append(points, [(to, (amount, 0))]);
        } else {
            let currentPoints = points[index].1;
            let newBongaPoints = currentPoints.0 + amount;
            points := replaceAt(points, index, (to, (newBongaPoints, currentPoints.1)));
        }
        return Result.Ok(());
    }

    public func issueNaivasLoyaltyPoints(to : principal, amount : nat64) : async Result<(), Text> {
        let index = indexOf(points, to);
        if (index == null) {
            points := Array.append(points, [(to, (0, amount))]);
        } else {
            let currentPoints = points[index].1;
            let newNaivasPoints = currentPoints.1 + amount;
            points := replaceAt(points, index, (to, (currentPoints.0, newNaivasPoints)));
        }
        return Result.Ok(());
    }

    public func redeemBongaPoints(from : principal, amount : nat64) : async Result<(), Text> {
        let index = indexOf(points, from);
        if (index == null) {
            return Result.Err("User not found");
        }

        let currentPoints = points[index].1;
        if (currentPoints.0 < amount) {
            return Result.Err("Insufficient BongaPoints");
        }

        let newBongaPoints = currentPoints.0 - amount;
        points := replaceAt(points, index, (from, (newBongaPoints, currentPoints.1)));
        return Result.Ok(());
    }

    public func redeemNaivasLoyaltyPoints(from : principal, amount : nat64) : async Result<(), Text> {
        let index = indexOf(points, from);
        if (index == null) {
            return Result.Err("User not found");
        }

        let currentPoints = points[index].1;
        if (currentPoints.1 < amount) {
            return Result.Err("Insufficient Naivas Loyalty Points");
        }

        let newNaivasPoints = currentPoints.1 - amount;
        points := replaceAt(points, index, (from, (currentPoints.0, newNaivasPoints)));
        return Result.Ok(());
    }

    public func getPoints(for : principal) : async ?(nat64, nat64) {
        let index = indexOf(points, `for`);
        if (index != null) {
            return ?points[index].1;
        } else {
            return null;
        }
    }
};
