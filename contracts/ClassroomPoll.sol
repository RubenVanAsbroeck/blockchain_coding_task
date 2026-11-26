// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

contract ClassroomPoll {
    struct Poll {
        string question;
        string[] options;
        uint256[] voteCounts;
        uint256 deadline;
        address creator;
        bool closed;
    }

    uint256 public nextPollId;
    mapping(uint256 => Poll) private polls;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event PollCreated(uint256 indexed pollId, address indexed creator, string question, uint256 deadline);
    event VoteCast(uint256 indexed pollId, address indexed voter, uint256 optionIndex);
    event PollClosed(uint256 indexed pollId);

    function createPoll(
        string calldata question,
        string[] calldata options,
        uint256 durationInSeconds
    ) external returns (uint256 pollId) {
        require(bytes(question).length > 0, "Question is required");
        require(options.length >= 2 && options.length <= 8, "Use 2 to 8 options");
        require(durationInSeconds > 0 && durationInSeconds <= 30 days, "Invalid duration");

        pollId = nextPollId++;
        Poll storage poll = polls[pollId];
        poll.question = question;
        poll.deadline = block.timestamp + durationInSeconds;
        poll.creator = msg.sender;

        for (uint256 i = 0; i < options.length; i++) {
            require(bytes(options[i]).length > 0, "Option is required");
            poll.options.push(options[i]);
            poll.voteCounts.push(0);
        }

        emit PollCreated(pollId, msg.sender, question, poll.deadline);
    }

    function vote(uint256 pollId, uint256 optionIndex) external {
        Poll storage poll = polls[pollId];
        require(bytes(poll.question).length > 0, "Poll does not exist");
        require(!poll.closed && block.timestamp < poll.deadline, "Poll is closed");
        require(optionIndex < poll.options.length, "Invalid option");
        require(!hasVoted[pollId][msg.sender], "Already voted");

        hasVoted[pollId][msg.sender] = true;
        poll.voteCounts[optionIndex]++;
        emit VoteCast(pollId, msg.sender, optionIndex);
    }

    function closePoll(uint256 pollId) external {
        Poll storage poll = polls[pollId];
        require(bytes(poll.question).length > 0, "Poll does not exist");
        require(msg.sender == poll.creator, "Only the creator can close");
        require(!poll.closed, "Poll is already closed");
        poll.closed = true;
        emit PollClosed(pollId);
    }

    function getPoll(uint256 pollId)
        external
        view
        returns (
            string memory question,
            string[] memory options,
            uint256[] memory voteCounts,
            uint256 deadline,
            address creator,
            bool closed
        )
    {
        Poll storage poll = polls[pollId];
        require(bytes(poll.question).length > 0, "Poll does not exist");
        return (poll.question, poll.options, poll.voteCounts, poll.deadline, poll.creator, poll.closed);
    }

    function isOpen(uint256 pollId) public view returns (bool) {
        Poll storage poll = polls[pollId];
        return bytes(poll.question).length > 0 && !poll.closed && block.timestamp < poll.deadline;
    }
}
