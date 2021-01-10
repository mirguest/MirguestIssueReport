import { useState } from 'react';
import logo from './logo.svg';
import './App.css';
import props from 'prop-types';

function App(props) {

  const [count, setCount] = useState(0);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Hello, {props.name} !</h1>
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
        <p>You clicked {count} times</p>
        <button onClick={() => setCount(count + 1)}>
          Click me
        </button>
      </header>
    </div>
  );
}

export default App;
