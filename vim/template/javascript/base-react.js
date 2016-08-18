import React, { Component, PropTypes } from 'react';

export default class Xxx extends Component {

  constructor(props) {
    super(props);
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
