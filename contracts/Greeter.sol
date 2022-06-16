pragma solidity 0.8.14;

contract VotingContract {
    uint256 constant MAX_VOTERS = 100000;

    string private _votePurpose;
    uint256 public _totalVotes;
    uint256 public _teamCount;
    mapping(uint256 => uint256) private _teamInfo;

    address private owner;

    struct Voter {
        bool isAuth;
        bool isVote;
    }

    mapping(address => Voter) _voteInfo;

    constructor(string name, uint256 teamCount) {
        _votePurpose = name;
        _teamCount = teamCount;
        owner = msg.sender;
    }

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    function authorize(address person) public ownerOnly {
        _voteInfo[person].isAuth = true;
    }

    function totalVotes() external view returns (uint256) {
        return _totalVotes;
    }

    function vote(address person, uint256 teamId) public ownerOnly {
        require(_voteInfo[person].isAuth, "Authorize first to vote");
        require(!_voteInfo[person].isVote, "Already voted");
        require(teamId <= _teamCount, "Invalid team Id");
        require(_totalVotes <= MAX_VOTERS, "Exceed max votes");

        _teamInfo[teamId]++;
        _voteInfo[person].isVote = true;
        _totalVotes++;
    }

    function resultOfVote() external view returns (uint256) {
        uint256 maxVotes = _totalVotes[0];
        uint256 maxTeam = 0;
        for (uint256 index = 1; index < _totalVotes.length; index++) {
            if (maxVotes < _totalVotes[index]) {
                maxVotes = _totalVotes[index];
                maxTeam = index;
            }
        }
        return index;
    }
}
