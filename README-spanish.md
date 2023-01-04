# Solucion al desafio #3 Universidad de Alchemy

Objetivos:
Al final de este tutorial, aprenderás a hacer lo siguiente:

    *  Cómo almacenar metadatos NFTs en cadena
    *  Qué es Polygon y por qué es importante para reducir las tasas de gas.
    *  Cómo desplegar en Polygon Mumbai
    *  Cómo procesar y almacenar en cadena imágenes SVG y objetos JSON
    *  Cómo modificar sus metadatos en función de sus interacciones con la NFT

## Iniciamos 🚀

_Estas instrucciones te permitirán tener una copia del proyecto corriendo en tu máquina local para_
_propósitos de desarrollo y pruebas._

Ver **Despliegue** para saber cómo desplegar el proyecto.

### Prerrequisitos 📋

    Para prepararte para el resto de este tutorial, necesitas tener:

    npm (npx) versión >= 8.5.5
    Versión de node >= 16.13.1
    Una cuenta de Alchemy (¡regístrate aquí gratis!)
    Añade Polygon Mumbai a tu cartera MetaMask
    Consigue MATIC gratis para desplegar tu Contrato Inteligente NFT

Lo siguiente no es necesario, pero es extremadamente útil:

    cierta familiaridad con una línea de comandos
    cierta familiaridad con JavaScript

Ahora vamos a empezar a construir nuestro contrato inteligente

### Instalación 🔧

_Instalación de todos los framework/bibliotecas necesarios_.

Abre tu terminal y crea un nuevo directorio:

```
mkdir NFTOnChainMetadata
cd NFTOnCHainMetada
```

instalar Hardhat ejecutando el siguiente comando:

```
yarn install hardhat
```

A continuación inicializa hardhat para crear los boilerplates del proyecto:

```
npx hardhat init
```

Deberías ver un mensaje de bienvenida y opciones sobre lo que puedes hacer. Selecciona Create a JavaScript (Todos los ajustes por defecto están bien):

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx
hardhat init
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

Welcome to Hardhat v2.12.4

✔ What do you want to do? · Create a JavaScript project
✔ Hardhat project root: · /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata
✔ Do you want to add a .gitignore? (Y/n) · y
✔ Do you want to install this sample project's dependencies with yarn (@nomicfoundation/
hardhat-toolbox @nomicfoundation/hardhat-network-helpers @nomicfoundation/hardhat-chai-matchers
@nomiclabs/hardhat-ethers @nomiclabs/hardhat-etherscan chai ethers hardhat-gas-reporter
solidity-coverage @typechain/hardhat typechain @typechain/ethers-v5 @ethersproject/abi @ethersproject/
providers)? (Y/n) · y
```

Para comprobar que todo funciona correctamente, ejecute

```
npx hardhat test
```

Si todo va bien, debes ver:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx
hardhat test
Compiled 1 Solidity file successfully


  Lock
    Deployment
      ✔ Should set the right unlockTime (2757ms)
      ✔ Should set the right owner (41ms)
      ✔ Should receive and store the funds to lock
      ✔ Should fail if the unlockTime is not in the future (79ms)
    Withdrawals
      Validations
        ✔ Should revert with the right error if called too soon (66ms)
        ✔ Should revert with the right error if called from another account (58ms)
        ✔ Shouldn't fail if the unlockTime has arrived and the owner calls it (82ms)
      Events
        ✔ Should emit an event on withdrawals (76ms)
      Transfers
        ✔ Should transfer the funds to the owner (79ms)


  9 passing (3s)
```

Ahora necesitaremos instalar el paquete OpenZeppelin para tener acceso al estándar de contratos inteligentes ERC721 que utilizaremos como plantilla para construir nuestro contrato inteligente NFTs.

```
yarn add @openzeppelin/contracts
```

Deberíamos observar algo similar a:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ yarn add
@openzeppelin/contracts
yarn add v1.22.17
warning package.json: No license field
warning No license field
[1/4] Resolving packages...
[2/4] Fetching packages...
[3/4] Linking dependencies...
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "@types/chai@^4.2.0".
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "@types/mocha@^9.1.0".
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "@types/node@>=12.0.0".
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "ts-node@>=8.0.0".
warning " > @nomicfoundation/hardhat-toolbox@2.0.0" has unmet peer dependency "typescript@>=4.5.0".
warning " > @typechain/ethers-v5@10.2.0" has unmet peer dependency "@ethersproject/bytes@^5.0.0".
warning " > @typechain/ethers-v5@10.2.0" has unmet peer dependency "typescript@>=4.3.0".
warning "@typechain/ethers-v5 > ts-essentials@7.0.3" has unmet peer dependency "typescript@>=3.7.0".
warning " > typechain@8.1.1" has unmet peer dependency "typescript@>=4.3.0".
[4/4] Building fresh packages...
success Saved lockfile.
warning No license field
success Saved 1 new dependency.
info Direct dependencies
└─ @openzeppelin/contracts@4.8.0
info All dependencies
└─ @openzeppelin/contracts@4.8.0
Done in 25.94s.
```

## Desarrollo de cambios en ficheros de configuración/Smart Contract ⚙️

Modifica el archivo hardhat.config.js. Abra el archivo hardhat.config.js contenido en la raíz de su
proyecto y dentro del objeto module.exports, copia el siguiente código:

```
module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
};
```

Cuando despleguemos nuestro contrato inteligente, también querremos verificarlo usando mumbai.
polygonscan, para ello necesitaremos proporcionar a Hardhat una clave API de etherscan o, en este caso, 
de Polygon scan.

Obtendremos la clave API de Polygonscan más adelante, por el momento, basta con añadir el siguiente 
código en el archivo hardhat.config.js:

```
etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  }
```

En este punto el archivo hardhar.config.js debe ser similar a:

```
require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  }
};
```

_Desarrollar el contrato inteligente_

En la carpeta de contratos, crea un nuevo archivo y llámalo "ChainBattles.sol".

Como siempre, tendremos que especificar el SPDX-Licence-Identifier, el pragma, y la importación de un par de bibliotecas de OpenZeppelin que utilizaremos como base de nuestro contrato inteligente:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
```

En este caso, estamos importando:

    El contrato ERC721URIStorage que se utilizará como base de nuestro contrato inteligente ERC721.
    La librería counters.sol, se encargará de manejar y almacenar nuestros tokenIDs
    La librería string.sol para implementar la función "toString()", que convierte los datos en cadenas 
    - secuencias de caracteres
    La librería Base64 que, como hemos visto anteriormente, nos ayudará a manejar datos base64 como 
    nuestros SVGs en cadena

A continuación, vamos a inicializar el contrato.

_Inicializar el contrato inteligente_

En primer lugar, tendremos que crear un nuevo contrato que herede de la extensión ERC721URIStorage
que importamos de OpenZeppelin. Dentro del contrato, inicializa la librería Strings and Counters:

```
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
}
```

Ahora que hemos inicializado nuestras librerías, declaramos una nueva función tokenIds que 
necesitaremos para almacenar nuestros ID de NFT:

```
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
}
```

La última variable global que debemos declarar es la asignación tokenIdToLevels, que utilizaremos para 
almacenar el nivel de un NFT asociado a su tokenId:

```
mapping(uint256 => uint256) public tokenIdToLevels;
```

El mapeo vinculará un uint256, el NFTId, a otro uint256, el nivel del NFT.

A continuación, tendremos que declarar la función constructora de nuestro contrato inteligente:

```
constructor() ERC721 ("Chain Battles", "CBTLS"){
}
```

Llegados a este punto, tu código debería tener el siguiente aspecto:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

}

mapping(uint256 => uint256) public tokenIdToLevels;

constructor() ERC721 ("Chain Battles", "CBTLS"){
}
```

Ahora que tenemos la base de nuestro contrato inteligente NFT, necesitaremos implementar 4 funciones 
diferentes funciones:

    generateCharacter: para generar y actualizar la imagen SVG de nuestro NFT
    getLevels: para obtener el nivel actual de un NFT
    getTokenURI: para obtener el TokenURI de un NFT
    mint: para acuñar - por supuesto
    train: para entrenar un NFT y subir su nivel

Lo bueno de los SVG es que pueden ser:

    Fácilmente modificables y generables mediante código
    Convertirse fácilmente en datos Base64

Ahora, usted podría preguntarse por qué queremos convertir archivos SVGs en datos Base64, la respuesta 
es muy simple:

Puede mostrar imágenes Base64 en el navegador sin necesidad de un proveedor de alojamiento.

Esto es útil porque, aunque Solidity no sea capaz de manejar imágenes, sí es capaz de manejar cadenas 
de caracteres y los SVG no son otra cosa que secuencias de etiquetas y cadenas que podemos recuperar 
fácilmente en tiempo de ejecución, además, convertir todo a base64, nos permitirá almacenar nuestras 
imágenes on-chain sin necesidad de almacenamiento de objetos.

Ahora que explicamos por qué los SVG son importantes, aprendamos a generar nuestros propios SVG en la 
cadena y a convertirlos en datos Base64.

_Crear la función generateCharacter para crear la imagen SVG_.

Necesitaremos una función que genere la imagen NFT on-chain, utilizando algún código SVG, teniendo en c
uenta el nivel del NFT.

Hacer esto en Solidity es un poco complicado, así que vamos a copiar el siguiente código primero, y 
luego iremos a través de las diferentes partes del mismo:

```
function generateCharacter(uint256 tokenId) public returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
        "Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
        "Levels: ",getLevels(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )
    );
}
```

Ahora que explicamos por qué los SVG son importantes, aprendamos a generar nuestros propios SVG en la 
cadena y a convertirlos en datos Base64. convertirlos en datos Base64.

_Crear la función generateCharacter para crear la imagen SVG_.

Lo primero que debe notar es el tipo "bytes", una matriz de tamaño dinámico de hasta 32 bytes donde 
puede almacenar cadenas y enteros.

En este caso, lo estamos utilizando para almacenar el código SVG que representa la imagen de nuestro 
NFT, transformado en un array de bytes gracias a la función abi.encodePacked() que toma una o más 
variables y las las codifica en abi.

Como se puede observar el código SVG toma el valor de retorno de una función getLevels() y lo utiliza 
para esta función más adelante, pero tenga en cuenta que puede usar funciones y variables para 
funciones y variables para cambiar dinámicamente sus SVG.

Como hemos visto antes, para visualizar una imagen en el navegador necesitaremos tener la versión 
base64 de la misma, no la versión en bytes. ella, no la versión en bytes - además, necesitaremos 
anteponer la cadena "data:image/svg+xml;base64," para especificar al navegador que la cadena Base64 es 
una imagen SVG y cómo abrirla.

Para ello, en el código anterior, estamos devolviendo la versión codificada de nuestro SVG convertido 
a Base64 utilizando Base64.encode() con la cadena de especificación del navegador añadida, utilizando 
la función abi.encodePacked().

Ahora que hemos implementado la función para generar nuestra imagen, necesitamos implementar una 
función para obtener el nivel de nuestros NFTs.

_Crear la función getLevels para obtener el nivel de los NFT_.

Para obtener el nivel de nuestro NFT, tendremos que utilizar el mapeo tokenIdToLevels que hemos 
declarado en nuestro pasando a la función el tokenId del que queremos obtener el nivel:

```
function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToLevels[tokenId];
    return levels.toString();
}
```

Como puedes ver esto fue bastante sencillo, lo único que hay que notar es la función toString(), que 
viene de la librería OpenZeppelin Strings, y transforma nuestro nivel, que es un uint256, en una 
cadena - que luego será utilizada por la función generateCharacter como hemos visto antes.

_Crear la función getTokenURI para generar el tokenURI_.

La función getTokenURI necesitará un parámetro, el tokenId, y lo utilizará para generar la imagen 
imagen y construir el nombre del NFT.

```
function getTokenURI(uint256 tokenId) public returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}
```

_Crear la función Mint para crear el NFT con metadatos en la cadena_.

La función menta en este caso tendrá 3 objetivos:

    Crear un nuevo NFT,
    Inicializar el valor de nivel,
    Establecer el token URI.

```
function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    tokenIdToLevels[newItemId] = 0;
    _setTokenURI(newItemId, getTokenURI(newItemId));
}
```

Como siempre, primero incrementamos el valor de nuestra variable \_tokenIds, y almacenamos su valor actual en una nueva variable uint256, en este caso, "newItemId".

A continuación, llamamos a la función \_safeMint() de la biblioteca OpenZeppelin ERC721, pasando la variable msg.sender y el id actual.

A continuación, creamos un nuevo elemento en la asignación tokenIdToLevels y asignamos su valor a 0, esto significa que nuestro carácter NFTs/ comenzará desde ese nivel.

Como última cosa, establecemos el URI del token pasando el newItemId y el valor de retorno de getTokenURI().

Esto acuñará un NFT cuyos metadatos, incluida la imagen, están completamente almacenados on-chain 🔥.

Eso también significa que podremos actualizar los metadatos directamente desde el Smart Contract, veamos cómo ¡crear una función para entrenar a nuestros NFTs y que suban de nivel!

_Crea la función entrenar para subir el nivel de tus NFT_

Como decíamos, ahora que los metadatos de nuestros NFTs están completamente on-chain, podremos interactuar con ellos directamente desde el contrato inteligente.

Supongamos que queremos subir el nivel de nuestros NFTs tras un entrenamiento intensivo, para ello tendremos que crear una función train que:

    Se asegure de que el NFT entrenado existe y que eres su propietario.
    Incremente el nivel de tu NFT en 1.
    Actualice el token URI para reflejar la formación.

```
function train(uint256 tokenId) public {
require(_exists(tokenId), "Please use an existing token");
require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
uint256 currentLevel = tokenIdToLevels[tokenId];
tokenIdToLevels[tokenId] = currentLevel + 1;
_setTokenURI(tokenId, getTokenURI(tokenId));
}
```

Como puedes observar, usando la función require(), estamos comprobando dos cosas:

    Si el token existe, usando la función _exists() del estándar ERC721,
    Si el propietario del NFT es el msg.sender (el monedero que llama a la función).

Una vez superadas ambas comprobaciones, obtenemos el nivel actual del NFT del mapeo, y lo 
incrementamos en uno.

Por último, llamamos a la función \_setTokenURI pasando el tokenId, y el valor de retorno de 
getTokenURI().

Al llamar a la función de tren ahora aumentará el nivel de la NFT y esto se reflejará automáticamente 
en la imagen.

El siguiente paso es desplegar el contrato inteligente en Polygon Mumbai e interactuar con él a través 
de Polygonscan. Para ello, necesitaremos coger nuestra clave de Alchemy y Polygonscan.

_Desplegar los NFT con el contrato inteligente On-Chain Metadata_

En primer lugar, vamos a crear un nuevo archivo .env en la carpeta raíz de nuestro proyecto, y añadir 
lo siguiente variables:

```
TESTNET_RPC=""
PRIVATE_KEY=""
POLYGONSCAN_API_KEY=""
```

A continuación, navega a alchemy.com y crea una nueva aplicación Polygon Mumbai:

Haz clic en la aplicación recién creada, copia la URL HTTP de la API y pégala como valor "TESTNET_RPC" 
en el archivo . env que creamos anteriormente.

Abre tu monedero Metamask, haz clic en el menú de los tres puntos > detalles de la cuenta > y copia y 
pega tu clave privada como valor "PRIVATE_KEY" en el archivo .env.

Por último, entra en polygonscan.com, y crea una nueva cuenta. Una vez que haya iniciado sesión, vaya 
a su perfil y haga clic en Claves API. Ahora copia y pega el Token Api-Key como valor 
"POLYGONSCANAPI_KEY" en el .env.

Un último paso antes de desplegar nuestro Smart contract, necesitaremos crear el script de despliegue.

_Crear el script de despliegue_

El script de despliegue, como su nombre indica, le dice a Hardhat cómo desplegar el contrato 
inteligente en el cadena de bloques especificada. Nuestro script de despliegue, en este caso, es 
bastante sencillo:

```
const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory(
      "ChainBattles"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
```

Estamos llamando a get.contractFactory, pasándole el nombre de nuestro contrato inteligente, desde 
Hardhat ethers. Nosotros luego llamamos a la función deploy() y esperamos a que se despliegue, 
registrando la dirección. Todo está Todo se envuelve en un bloque try{} catch{} para capturar 
cualquier error que pueda ocurrir e imprimirlo con fines de depuración. Ahora que nuestro script de 
despliegue está listo, es el momento de compilar y desplegar nuestra dinámica NFT en Polygon Mumbai.

_Compilar y desplegar el contrato inteligente_

Para compilar el contrato inteligente simplemente ejecute el siguiente comando, en el terminal dentro 
del proyecto:

```
npx hardhat compile
```

Si aparece el siguiente error:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
compile
An unexpected error occurred:

Error: Cannot find module 'dotenv'
Require stack:
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.config.js
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/core/
config/config-loading.js
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/cli/cli.
js
    at Function.Module._resolveFilename (node:internal/modules/cjs/loader:985:15)
    at Function.Module._load (node:internal/modules/cjs/loader:833:27)
    at Module.require (node:internal/modules/cjs/loader:1057:19)
    at require (node:internal/modules/cjs/helpers:103:18)
    at Object.<anonymous> (/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.
    config.
    js:1:1)
    at Module._compile (node:internal/modules/cjs/loader:1155:14)
    at Object.Module._extensions..js (node:internal/modules/cjs/loader:1209:10)
    at Module.load (node:internal/modules/cjs/loader:1033:32)
    at Function.Module._load (node:internal/modules/cjs/loader:868:12)
    at Module.require (node:internal/modules/cjs/loader:1057:19) {
  code: 'MODULE_NOT_FOUND',
  requireStack: [
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.config.js',
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/core/
    config/config-loading.js',
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/cli/
    cli.
    js'
  ]
}
```

A continuación, abra el terminal en el directorio raíz del proyecto (donde se encuentra el archivo 
package.json) y ejecute el siguiente comando:

```
npm install dotenv
```

Si aparece este otro error:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
compile
An unexpected error occurred:

Error: Cannot find module '@nomiclabs/hardhat-waffle'
Require stack:
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.config.js
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/core/
config/config-loading.js
- /home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/cli/cli.
js
    at Function.Module._resolveFilename (node:internal/modules/cjs/loader:985:15)
    at Function.Module._load (node:internal/modules/cjs/loader:833:27)
    at Module.require (node:internal/modules/cjs/loader:1057:19)
    at require (node:internal/modules/cjs/helpers:103:18)
    at Object.<anonymous> (/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.
    config.js:2:1)
    at Module._compile (node:internal/modules/cjs/loader:1155:14)
    at Object.Module._extensions..js (node:internal/modules/cjs/loader:1209:10)
    at Module.load (node:internal/modules/cjs/loader:1033:32)
    at Function.Module._load (node:internal/modules/cjs/loader:868:12)
    at Module.require (node:internal/modules/cjs/loader:1057:19) {
  code: 'MODULE_NOT_FOUND',
  requireStack: [
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/hardhat.config.js',
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/core/
    config/config-loading.js',
    '/home/llabori/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata/node_modules/hardhat/internal/cli/
    cli.js'
  ]
}
```

A continuación, abra el terminal en el directorio raíz del proyecto (donde se encuentra el archivo 
package.json) y ejecute el siguiente comando:

```
npm install --save-dev @nomiclabs/hardhat-waffle 'ethereum-waffle@^3.0.0' @nomiclabs/hardhat-ethers
'ethers@^5.0.0'
```

Para recompilar el contrato inteligente simplemente ejecute el siguiente comando, en el terminal 
dentro del proyecto:

```
npx hardhat compile
```

Deberías ver:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
compile 
Compiled 14 Solidity files successfully
```

Si todo va según lo esperado, verás tu contrato inteligente compilado dentro de la carpeta de 
artefactos.

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "a title")

Ahora, despleguemos el contrato inteligente en la cadena Polygon Mumbai en ejecución:

```
npx hardhat run scripts/deploy.js --network mumbai
```

Espere 10-15 segundos y debería ver la dirección de su contrato Smart impresa en su terminal:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
run scripts/deploy.js --network mumbai
Contract deployed to: 0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0 NOTE = You contract address is 
diferent to this
```

_Compruebe su contrato inteligente en Polygon Scan_.

Copie la dirección del contrato inteligente recién desplegado, vaya a mumbai.polygonscan.com, y pegue 
la dirección del contrato inteligente en la barra de búsqueda.

Una vez en la página de tu contrato inteligente, haz clic en la pestaña "Contrato".

Verás que el código del contrato no es legible

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "a title")

Esto se debe a que aún no hemos verificado nuestro código.

Para verificar nuestro contrato inteligente tendremos que volver a nuestro proyecto, y, en el 
terminal, ejecutar lo siguiente código:

```
npx hardhat verify --network mumbai YOUR_SMARTCONTRACT_ADDRESS
For me:
npx hardhat verify --network mumbai 0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0
```

Verás:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat
verify --network mumbai 0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0
Nothing to compile
Successfully submitted source code for contract
contracts/ChainBattles.sol:ChainBattles at 0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0
for verification on the block explorer. Waiting for verification result...

Successfully verified contract ChainBattles on Etherscan.
https://mumbai.polygonscan.com/address/0xb511efAe8161EAF9983fB26A456D6F1f7b3955C0#code
```

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "a title")

Para interactuar con él, y acuñar el primer NFT, haga clic en el botón "Escribir contrato" en la pestaña 
"contrato", y haga clic en "conectar a Web3"

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "un título")

Esto abrirá una ventana emergente Metamask que le pedirá que pague las tasas de gas, haga clic en el 
botón firmar.

¡Enhorabuena! Acabas de acuñar tu primera NFT dinámica - vamos a pasar a OpenSea Testnet para verla en 
directo.

_Ver tu NFT dinámico en OpenSea_

Copia la dirección del contrato inteligente, ve a testnet.opensea.com y pégala en la barra de búsqueda:

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "un título")

Si todo ha funcionado como esperabas, ahora deberías ver tu NFT mostrándose en OpenSea, con su imagen 
dinámica, el título y la descripción. Nada nuevo hasta ahora, ya construimos una colección NFT en la 
primera lección. Lo interesante es que ahora podemos actualizar la imagen en tiempo real.

Volvamos a Polygon Scan.

_Actualizar la Imagen NFT Dinámica Entrenando el NFT_

Navegue de nuevo a mumbai.polygonscan.com, haga clic en la pestaña contrato > Escribir contrato y busque 
la función función "entrenar".

Inserte el ID de su NFT - "1" en este caso, ya que acuñamos sólo uno, y haga clic en Escribir:

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "un título")

A continuación, vuelve a testnets.opensea.com y actualiza la página:

![Alt text](https://www.github.com/assets.digitalocean.com/articles/alligator/boo.svg "un título")

## Desafio ⚙️

De momento sólo almacenamos el nivel de nuestros NFT, ¿por qué no almacenar más?

Sustituye la actual asignación tokenIdToLevels[] por una estructura que almacene:

    Nivel
    Velocidad
    Fuerza
    Vida

Puedes leer más sobre structs en esta guía.

Una vez que hayas creado la estructura, inicializa las estadísticas en la función mint(), para ello es 
posible que desees mirar en la generación de pseudo números en Solidity.

El resultado después de ejecutar los cambios en el Smart Contract debería ser similar a:

```
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat compile
Compiled 1 Solidity file successfully
llabori@Xubuntu64Bits-virtual-machine:~/BlockChains/AlchemyUniversity/3-NFTOnChainMetadata$ npx hardhat run scripts/deployUpd.js --network mumbai
Contract deployed to: 0x6A4481b500E143aF4032d2ace316AFb557628873 NOTE = You contract address is diferent
to this
```

Y asegúrate de compartir tus reflexiones sobre este proyecto para ganar tu Proof of Knowledge (PoK) token:
https://university.alchemy.com/discord


## Construido con 🛠️

_Herramientas que se utilizaron para crear el proyecto/Desafio_

- [Visual Studio Code](https://code.visualstudio.com/) - El IDE
- [Alchemy](https://dashboard.alchemy.com) - Interfaz/API para la Red Goerli Tesnet
- [Xubuntu](https://xubuntu.org/) - Sistema operativo basado en la distribución Ubuntu
- [Polygon/Mumbai](https://mumbai.polygonscan.com/) - Sistema web utilizado para verificar transacciones, 
  verificar contratos, desplegar contratos, verificar y publicar el código fuente de los contratos, etc; 
  para la red Polygon.
- [Polygon Scan](https://polygonscan.com) - Para generar las claves API para interactuar con Polygon 
  Mumbai Tesnet.
- [Opensea](https://testnets.opensea.io) - Sistema web utilizado para verificar/visualizar nuestras NFT
- [Solidity](https://soliditylang.org) Lenguaje de programación orientado a objetos para implementar
  contratos inteligentes en varias plataformas de cadenas de bloques.
- [Hardhat](https://hardhat.org) - Entorno utilizado por los desarrolladores para probar, compilar,
  desplegar y depurar dApps basadas en la cadena de bloques Ethereum.
- [GitHub](https://github.com/) - Servicio de alojamiento en Internet para el desarrollo de software y
  el control de versiones mediante Git.
- [Faucet Mumbai](https://mumbaifaucet.com/) - Grifo utilizado para obtener MATIC de prueba utilizados en 
  las pruebas para desplegar los SmartContrat así como para interactuar con ellos.
- [MetaMask](https://metamask.io) - MetaMask es una cartera de criptodivisas de software utilizada
  para interactuar con la blockchain de Ethereum.

## Contribuir 🖇️

Por favor, lee [CONTRIBUTING.md](https://gist.github.com/llabori-venehsoftw/xxxxxx) para más detalles sobre
nuestro código de conducta, y el proceso para enviarnos pull requests.

## Wiki 📖

N/A

## Versionado 📌

Utilizamos [GitHub] para versionar todos los archivos utilizados (https://github.com/tu/proyecto/tags).

## Autores ✒️

_Personas que colaboraron con el desarrollo del reto_.

- **VeneHsoftw** - _Trabajo Inicial_ - [venehsoftw](https://github.com/venehsoftw)
- **Luis Labori** - _Trabajo inicial_, _Documentaciónn_ - [llabori-venehsoftw](https://github.com/
  llabori-venehsoftw)

## Licencia 📄

Este proyecto está licenciado bajo la Licencia (Su Licencia) - ver el archivo [LICENSE.md](LICENSE.md)
para más detalles.

## Gratitud 🎁

- Si la información reflejada en este Repo te ha parecido de gran importancia, por favor, amplía tu
  colaboración pulsando el botón de la estrella en el margen superior derecho. 📢
- Si está dentro de sus posibilidades, puede ampliar su donación a través de la siguiente dirección:
  `0xAeC4F555DbdE299ee034Ca6F42B83Baf8eFA6f0D`

---

⌨️ con ❤️ por [Venehsoftw](https://github.com/llabori-venehsoftw) 😊
