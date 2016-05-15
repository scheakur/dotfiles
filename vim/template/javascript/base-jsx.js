import React, { Component, PropTypes } from 'react';

export default class Xxx extends Component {

  constructor() {
    super();
  }

  render() {
    return (
      <div></div>
    );
  }

}


Xxx.propTypes = {
  yyy: PropTypes.string,
};


Xxx.defaultProps = {
  yyy: 'foo',
};

