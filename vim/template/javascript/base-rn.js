import React, {
  Component,
  PropTypes,
} from 'react';

import {
  StyleSheet,
  Text,
  View,
} from 'react-native';


const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    fontSize: 20,
    color: '#f00',
  },
});


export default class Xxx extends Component {

  render() {
    return (
      <View style={[styles.container, this.props.style]}>
        <Text style={styles.text}>xxx</Text>
        {this.props.children}
      </View>
    );
  }

}


Xxx.propTypes = {
  yyy: PropTypes.string,
  style: PropTypes.oneOfType([
    PropTypes.object,
    PropTypes.number,
    PropTypes.array,
  ]),
  children: PropTypes.node,
};


Xxx.defaultProps = {
  yyy: 'foo',
};
