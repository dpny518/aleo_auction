#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

echo "
We will be playing the role of three parties.

The private key and address of the first bidder.
private_key: APrivateKey1zkpBdbyK1xHQzKCqBQqr5DpEc6WmD6BBCHUPQnKTDzzsrmf
address: aleo1nhl0rlqfrw3uhy6q3we0quk4fn779rq6y9drt3zvdr3vtntqscysz0w3wy

The private key and address of the second bidder.
private_key: APrivateKey1zkpADXsLcW5Z2KyLxwFV7Kw5yFLgaEjADFWdvQSjq4V9DeS
address: aleo1qv3a9t45kgpre4erueu8am62efqnvzw38pcqnglcnzrsgpjd5vgswn9lq8

The private key and address of the auctioneer.
private_key: APrivateKey1zkp3BLYDGjxba1BSJ3u363MJwJe9TGMRhxDsSHdCWKqrYgf
address: aleo1snt5w69etddrq0eq4xwapppa8zt4ya6zjfttz59xaap96v0t6q9sq6a585
"

echo "
Let's start an auction!

###############################################################################
########                                                               ########
########           Step 0: Initialize a new 2-party auction            ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |         |         |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

echo "
Let's take the role of the first bidder - we'll swap in the private key and address of the first bidder to .env.

We're going to run the transition function "place_bid", slotting in the first bidder's public address and the amount that is being bid. The inputs are the user's public address and the amount being bid.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpBdbyK1xHQzKCqBQqr5DpEc6WmD6BBCHUPQnKTDzzsrmf
' > .env

leo run place_bid aleo1nhl0rlqfrw3uhy6q3we0quk4fn779rq6y9drt3zvdr3vtntqscysz0w3wy 10u64
"

# Swap in the private key of the first bidder to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpBdbyK1xHQzKCqBQqr5DpEc6WmD6BBCHUPQnKTDzzsrmf
" > .env

# Have the first bidder place a bid of 10.
leo run place_bid aleo1nhl0rlqfrw3uhy6q3we0quk4fn779rq6y9drt3zvdr3vtntqscysz0w3wy 10u64

echo "
###############################################################################
########                                                               ########
########         Step 1: The first bidder places a bid of 10           ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |         |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

echo "
Now we're going to place another bid as the second bidder, so let's switch our keys to the second bidder and run the same transition function, this time with the second bidder's keys, public address, and different amount.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpADXsLcW5Z2KyLxwFV7Kw5yFLgaEjADFWdvQSjq4V9DeS
' > .env

leo run place_bid aleo1qv3a9t45kgpre4erueu8am62efqnvzw38pcqnglcnzrsgpjd5vgswn9lq8 90u64
"

# Swap in the private key of the second bidder to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpADXsLcW5Z2KyLxwFV7Kw5yFLgaEjADFWdvQSjq4V9DeS
" > .env

# Have the second bidder place a bid of 90.
leo run place_bid aleo1qv3a9t45kgpre4erueu8am62efqnvzw38pcqnglcnzrsgpjd5vgswn9lq8 90u64

echo "
###############################################################################
########                                                               ########
########          Step 2: The second bidder places a bid of 90         ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |    B    |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |   90    |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

echo "
Now, let's take the role of the auctioneer, so we can determine which bid wins. Let's swap our keys to the auctioneer and run the resolve command on the output of the two bids from before. The resolve command takes the two output records from the bids as inputs and compares them to determine which bid wins.

echo '
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp3BLYDGjxba1BSJ3u363MJwJe9TGMRhxDsSHdCWKqrYgf
' > .env

leo run resolve '{
        owner: aleo1snt5w69etddrq0eq4xwapppa8zt4ya6zjfttz59xaap96v0t6q9sq6a585.private,
        bidder: aleo1nhl0rlqfrw3uhy6q3we0quk4fn779rq6y9drt3zvdr3vtntqscysz0w3wy.private,
        amount: 10u64.private,
        is_winner: false.private,
        _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
    }' '{
        owner: aleo1snt5w69etddrq0eq4xwapppa8zt4ya6zjfttz59xaap96v0t6q9sq6a585.private,
        bidder: aleo1qv3a9t45kgpre4erueu8am62efqnvzw38pcqnglcnzrsgpjd5vgswn9lq8.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }'
"

# Swaps in the private key of the auctioneer to .env.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp3BLYDGjxba1BSJ3u363MJwJe9TGMRhxDsSHdCWKqrYgf
" > .env

# Have the auctioneer select the winning bid.
leo run resolve "{
        owner: aleo1snt5w69etddrq0eq4xwapppa8zt4ya6zjfttz59xaap96v0t6q9sq6a585.private,
        bidder: aleo1nhl0rlqfrw3uhy6q3we0quk4fn779rq6y9drt3zvdr3vtntqscysz0w3wy.private,
        amount: 10u64.private,
        is_winner: false.private,
        _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
    }" "{
        owner: aleo1snt5w69etddrq0eq4xwapppa8zt4ya6zjfttz59xaap96v0t6q9sq6a585.private,
        bidder: aleo1qv3a9t45kgpre4erueu8am62efqnvzw38pcqnglcnzrsgpjd5vgswn9lq8.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }"

echo "
###############################################################################
########                                                               ########
########     Step 3: The auctioneer determines the winning bidder      ########
########                                                               ########
########                -------------------------------                ########
########                |  OPEN   |    A    |  → B ←  |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |  → 90 ← |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"

echo "
Keeping the key environment the same since we're still the auctioneer, let's finalize the auction and label the winning output as the winner. The finish transition takes the winning output bid as the input and marks it as such.

leo run finish '{
        owner: aleo1snt5w69etddrq0eq4xwapppa8zt4ya6zjfttz59xaap96v0t6q9sq6a585.private,
        bidder: aleo1qv3a9t45kgpre4erueu8am62efqnvzw38pcqnglcnzrsgpjd5vgswn9lq8.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }'
"

# Have the auctioneer finish the auction.
leo run finish "{
        owner: aleo1snt5w69etddrq0eq4xwapppa8zt4ya6zjfttz59xaap96v0t6q9sq6a585.private,
        bidder: aleo1qv3a9t45kgpre4erueu8am62efqnvzw38pcqnglcnzrsgpjd5vgswn9lq8.private,
        amount: 90u64.private,
        is_winner: false.private,
        _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
    }"

echo "
###############################################################################
########                                                               ########
########              The auctioneer completes the auction.            ########
########                                                               ########
########                -------------------------------                ########
########                |  CLOSE  |    A    |  → B ←  |                ########
########                -------------------------------                ########
########                |   Bid   |   10    |  → 90 ← |                ########
########                -------------------------------                ########
########                                                               ########
###############################################################################
"
