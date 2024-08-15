actor LoyaltyPoints {
    

    public func issueBongaPoints(to : principal, amount : nat64) : async Result<(), Text> {
      //Logic to issue BongaPoints
      let index = indexOf(points, to);
        if (index == null) {
            points = [*(points), (to, (amount, 0))];
        } else {
            let currentPoints = points[index].1;
            let newBongaPoints = currentPoints.0 + amount;
            points = replace_at(points, index, (to, (newBongaPoints, currentPoints.1)));
        }
        return ok();
    };

    public func issueNaivasLoyaltyPoints(to : principal, amount : nat64) : async Result<(), Text> {
      //Logic to issue Naivas Loyalty Points
      let index = indexOf(points, to);
        if (index == null) {
            points = [*(points), (to, (0, amount))];
        } else {
            let currentPoints = points[index].1;
            let newNaivasPoints = currentPoints.1 + amount;
            points = replace_at(points, index, (to, (currentPoints.0, newNaivasPoints)));
        }
        return ok();
    };

    public func redeemBongaPoints(from : principal, amount : nat64) : async Result<(), Text> {
      //Logic to redeem BongaPoints
      let index = indexOf(points, from);
        if (index == null) {
            return err "User not found";
        }

        let currentPoints = points[index].1;
        if (currentPoints.0 < amount) {
            return err "Insufficient BongaPoints";
        }

        let newBongaPoints = currentPoints.0 - amount;
        points = replace_at(points, index, (from, (newBongaPoints, currentPoints.1)));
        return ok();
    };

    public func redeemNaivasLoyaltyPoints(from : principal, amount : nat64) : async Result<(), Text> {
      //Logic to redeem Naivas Loyalty Points
      let index = indexOf(points, from);
        if (index == null) {
            return err "User not found";
        }

        let currentPoints = points[index].1;
        if (currentPoints.1 < amount) {
            return err "Insufficient Naivas Loyalty Points";
        }

        let newNaivasPoints = currentPoints.1 - amount;
        points = replace_at(points, index, (from, (currentPoints.0, newNaivasPoints)));
        return ok();
    };

    public func getPoints(for : principal) : async ?(nat64, nat64) {
      //Logic to retrieve both BongaPoints and Naivas Loyalty Points
      let index = indexOf(points, for);
        if (index != null) {
            return Some(points[index].1);
        } else {
            return None;
        }
    };

};
