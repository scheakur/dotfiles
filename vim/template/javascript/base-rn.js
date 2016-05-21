import React, {
  Component,
  PropTypes,
} from 'react';

import {
  StyleSheet,
  Text,
  View,
} from 'react-native';

export default class Xxx extends Component {

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.text}>xxx</Text>
      </View>
    );
  }

}


Xxx.propTypes = {
  yyy: PropTypes.string,
};


Xxx.defaultProps = {
  yyy: 'foo',
};


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
