import React, {
  Component,
  StyleSheet,
  View,
  Text,
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
