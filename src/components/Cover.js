import React from 'react';
import { Button } from "react-bootstrap";
import PropTypes from 'prop-types';

const myStyle={
  height:'100vh',
  marginTop: "-250px"
};
const Cover = ({ name, coverDescription,connect }) => {
  if (name) {
    return (
      <div
          className="text-center "
          style={myStyle}
        >

          <div className="mt-auto text-light mb-0 bg-dark">
            <div
              className=" ratio ratio-1x1 mx-auto mb-2"
              style={{ maxWidth: "320px" }}
            >
            </div>
            <div style={{ margin: '100px' }}>
            <img src="https://i.ibb.co/5hNppMg/okazi-soup-1-8.webp" alt="africa dishes variety" style={{ width: '400px', }}/>
            </div>
            <h1>{name}</h1>
            <p>{coverDescription}</p>
            <br></br>
            <p>Please connect your wallet to continue.</p>
            <Button
              onClick={() => connect().catch((e) => console.log(e))}
              variant="btn btn-light"
              className="rounded-pill px-3 mt-3 mb-5"
            >
              Connect Wallet
            </Button>
          </div>

        </div>
    );
  }

  return null;
};


Cover.propTypes = {
  // props passed into this component
  name: PropTypes.string,
};

Cover.defaultProps = {
  name: '',
};

export default Cover;
