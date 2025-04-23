// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract BikeChain {
    struct Player {
        uint256 energy;
        uint256 distance;
        bool joined;
    }

    mapping(address => Player) public players;
    address[] public racerList;
    uint256 public raceLength = 1000; // in meters
    bool public raceStarted;
    address public winner;

    modifier onlyInRace() {
        require(players[msg.sender].joined, "You are not in the race");
        _;
    }

    function joinRace() external {
        require(!raceStarted, "Race already started");
        require(!players[msg.sender].joined, "Already joined");

        players[msg.sender] = Player({
            energy: 100,
            distance: 0,
            joined: true
        });
        racerList.push(msg.sender);
    }

    function startRace() external {
        require(!raceStarted, "Race already started");
        require(racerList.length > 1, "Need at least 2 racers");
        raceStarted = true;
    }

    function pedal() external onlyInRace {
        require(raceStarted, "Race not started");
        Player storage p = players[msg.sender];
        require(p.energy > 0, "Out of energy");
        require(p.distance < raceLength, "You already finished");

        p.energy -= 10;
        p.distance += 100;

        if (p.distance >= raceLength && winner == address(0)) {
            winner = msg.sender;
        }
    }

    function getStatus(address player) external view returns (uint256 energy, uint256 distance, bool isWinner) {
        Player memory p = players[player];
        return (p.energy, p.distance, player == winner);
    }

    function getRacers() external view returns (address[] memory) {
        return racerList;
    }
} 
