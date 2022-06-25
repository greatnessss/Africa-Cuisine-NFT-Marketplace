import React from "react";
import Cover from "./components/Cover";
import { Notification } from "./components/ui/Notifications";
import Wallet from "./components/wallet";
import { useBalance, useMinterContract } from "./hooks";

import Nfts from "./components/minter/nfts";
import { useContractKit } from "@celo-tools/use-contractkit";

import "./App.css";

import { Container, Nav } from "react-bootstrap";

const App = function AppWrapper() {
  const myStyle={
    backgroundColor: 
    "black",
    height:'100vh',
    marginTop:'0px',
    fontSize:'18px',
    backgroundSize: 'cover',
    backgroundRepeat: 'no-repeat',
  };
  const { address, destroy, connect } = useContractKit();

  //  fetch user's celo balance using hook
  const { balance, getBalance } = useBalance();

  // initialize the NFT mint contract
  const minterContract = useMinterContract();

  return (
    <>
      <Notification />

      {address ? (
        <Container fluid="md">
          <Nav className="justify-content-end pt-3 pb-5">
            <Nav.Item>
              {/*display user wallet*/}
              <Wallet
                address={address}
                amount={balance.CELO}
                symbol="CELO"
                destroy={destroy}
              />
            </Nav.Item>
          </Nav>
          <main>
            {/*list NFTs*/}
            <Nfts className="bg-dark text-dark"
              name="Africa Cuisine NFT Marketplace"
              updateBalance={getBalance}
              minterContract={minterContract}
            />
          </main>
        </Container>
      ) : (
        <Cover name="Africa Cuisine NFT Marketplace" coverDescription ="Showcasing and celebrating African Delicacies" connect={connect} />
      )}
    </>
  );
};

export default App;
