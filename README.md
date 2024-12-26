# Roulette Game - Smart Contract Project

## Giới thiệu

Dự án này là một trò chơi Roulette được triển khai bằng hợp đồng thông minh trên Ethereum. Bạn sẽ tìm thấy mã nguồn hợp đồng thông minh Solidity trong thư mục này. Dưới đây là hướng dẫn để bạn có thể clone code về và triển khai Hardhat để làm việc với nó.

## Yêu cầu

Trước khi bắt đầu, bạn cần cài đặt một số công cụ sau:

1. **Node.js**: Bạn cần Node.js để chạy Hardhat và các package liên quan.
   - Tải và cài đặt Node.js từ [Node.js Official Website](https://nodejs.org/).
   
2. **npm hoặc yarn**: npm là công cụ quản lý gói đi kèm với Node.js, hoặc bạn có thể cài đặt yarn.
   - Cài đặt npm thông qua Node.js.


3. **Git**: Để clone repository từ GitHub.
   - Tải và cài đặt Git từ [Git Official Website](https://git-scm.com/).

4. **Hardhat**: Đây là framework để phát triển hợp đồng thông minh trên Ethereum.
   - Hardhat sẽ được cài đặt trong dự án của bạn.

## Các bước triển khai

### 1. Clone Repository

Đầu tiên, clone repository về máy tính của bạn:

```bash
git clone https://github.com/Khang03z/Roulette-Game.git

cd Roulette-Game

```

2. Cài đặt các phụ thuộc

Trong thư mục dự án, chạy lệnh sau để cài đặt các phụ thuộc cần thiết (bao gồm cả Hardhat): 

```bash
npm install

```

3. Cài đặt Hardhat
Nếu chưa cài đặt Hardhat, bạn có thể cài đặt nó bằng cách chạy lệnh: 

``` bash
npx hardhat
```

Lệnh trên sẽ giúp bạn thiết lập Hardhat trong dự án của mình. 

4. Cấu hình Mạng Local: Để chạy Hardhat trên mạng local, bạn có thể khởi động Hardhat Network bằng cách chạy lệnh sau: 

``` bash
npx hardhat node
```

Điều này sẽ bắt đầu một mạng blockchain local, và bạn có thể triển khai các hợp đồng lên đó.

Sau đó có thể triển khai hợp đồng bằng cách chạy lệnh: 
``` bash
npx hardhat run scripts/deploy.js --network localhost
```

=> Triển khai thành công 3 contract ở local. 