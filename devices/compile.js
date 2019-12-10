/* CREDIT:
 * Build Smart Contract without Truffle, just Solcjs:
 * https://medium.com/coinmonks/build-smart-contract-without-truffle-just-solcjs-solidity-tutorial-1-4434f98dbb18
 */

const path = require('path');
const fs = require('fs');
const solc = require('solc');
const md5File = require('md5-file');

const Compile = {
  // Input parameters for solc
  // Refer to https://solidity.readthedocs.io/en/develop/using-the-compiler.html#compiler-input-and-output-json-description
  solcInput: {
    language: 'Solidity',
    sources: {},
    settings: {
      optimizer: {
        enabled: true,
      },
      evmVersion: 'byzantium',
      outputSelection: {
        '*': {
          '': ['legacyAST', 'ast'],
          '*': [
            'abi',
            'evm.bytecode.object',
            'evm.bytecode.sourceMap',
            'evm.deployedBytecode.object',
            'evm.deployedBytecode.sourceMap',
            'evm.gasEstimates',
          ],
        },
      },
    },
  },

  // Lookup imported sol files in "contracts" folder
  findImports(importFile) {
    console.log(`Import File:${importFile}`);

    try {
      // Find in contracts folder first
      const result = fs.readFileSync(`contracts/${importFile}`, 'utf8');
      return { contents: result };
    } catch (error) {
      console.log(error.message);
      return { error: 'File not found' };
    }
  },

  // Compile the sol file in "contracts" folder and output the built json file to ".build/contracts"
  buildContract(contract) {
    const contractFile = `contracts/${contract}`;
    const jsonOutputName = `${path.parse(contract).name}.json`;
    const jsonOutputFile = `./.built_contracts/${jsonOutputName}`;

    const contractFileChecksum = md5File.sync(contractFile);

    try {
      fs.statSync(jsonOutputFile);

      const jsonContent = fs.readFileSync(jsonOutputFile, 'utf8');
      const jsonObject = JSON.parse(jsonContent);
      let buildChecksum = '';
      if (typeof jsonObject.contracts[contract].checksum !== 'undefined') {
        buildChecksum = jsonObject.contracts[contract].checksum;

        console.log(`File Checksum: ${contractFileChecksum}`);
        console.log(`Build Checksum: ${buildChecksum}`);

        if (contractFileChecksum === buildChecksum) {
          console.log('No build is required due no change in file.');
          console.log('==============================');
          return true;
        }
      }
    } catch (error) {
      // Any file not found, will continue build
    }

    const contractContent = fs.readFileSync(contractFile, 'utf8');
    console.log(`Contract File: ${contract}`);

    this.solcInput.sources[contract] = {
      content: contractContent,
    };

    const solcInputString = JSON.stringify(this.solcInput);
    const output = solc.compileStandardWrapper(
      solcInputString,
      this.findImports
    );

    const jsonOutput = JSON.parse(output);
    let isError = false;

    if (jsonOutput.errors) {
      jsonOutput.errors.forEach(error => {
        console.log(
          `${error.severity}: ${error.component}: ${error.formattedMessage}`
        );
        if (error.severity === 'error') {
          isError = true;
        }
      });
    }

    if (isError) {
      // Compilation errors
      console.log('Compile error!');
      return false;
    }

    // Update the sol file checksum
    jsonOutput.contracts[contract].checksum = contractFileChecksum;

    const formattedJson = JSON.stringify(jsonOutput, null, 4);

    // Check if .built_contracts exist, if not, make 1
    const buildDir = './.built_contracts';
    if (!fs.existsSync(buildDir)) {
      fs.mkdirSync(buildDir);
    }
    // Write the output JSON
    fs.writeFileSync(`./.built_contracts/${jsonOutputName}`, formattedJson);

    return true;
  },
};

module.exports = Compile;
