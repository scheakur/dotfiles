const xhr = new XMLHttpRequest();
const params = 'foo=bar&hoge=fuga';

xhr.open('POST', 'http://localhost:8000', true);

xhr.onreadystatechange = () => {
  if (xhr.readyState == 4 && xhr.status == 200) {
    console.log(this.responseText);
  }
};

xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
xhr.setRequestHeader('Content-length', params.length);

xhr.send(params);
