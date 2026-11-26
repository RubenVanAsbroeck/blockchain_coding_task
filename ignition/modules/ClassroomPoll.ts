import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("ClassroomPollModule", (m) => {
  const poll = m.contract("ClassroomPoll");
  return { poll };
});
