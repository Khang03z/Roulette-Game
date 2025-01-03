# Hướng Dẫn Kiểm Tra Các Smart Contract: PlayerManager & BetManager

Chào mừng bạn đến với hướng dẫn kiểm tra hai smart contract **PlayerManager** và **BetManager**! Trong hướng dẫn này, chúng ta sẽ đi qua từng chức năng của các smart contract, từ việc đăng ký người chơi cho đến việc đặt cược và quay bánh xe. Hãy cùng khám phá các tính năng mạnh mẽ này và kiểm tra chúng trên **Remix IDE**.

---

## 🚀 Giới Thiệu

### **PlayerManager Contract**:
Đây là contract chịu trách nhiệm quản lý các người chơi trong hệ thống. Các chức năng của nó bao gồm:
- Đăng ký người chơi
- Nạp và rút tiền cho người chơi
- Kiểm tra số dư của người chơi

### **BetManager Contract**:
BetManager giúp quản lý quá trình đặt cược, quay bánh xe và phân phối phần thưởng cho người chơi dựa trên kết quả của trò chơi. Các chức năng chính:
- Đặt cược vào trò chơi
- Quay bánh xe với kết quả ngẫu nhiên
- Phân phối phần thưởng sau khi có kết quả

---

## 🔧 Cài Đặt và Triển Khai

### Bước 1: Truy Cập Remix IDE
Mở **[Remix IDE](https://remix.ethereum.org/)**, một công cụ phát triển mạnh mẽ cho việc viết, biên dịch và triển khai smart contract.

### Bước 2: Biên Dịch Các Smart Contract
1. **Chuyển đến tab Solidity Compiler**.
2. Tải lên các tệp smart contract của bạn: `PlayerManager.sol` và `BetManager.sol`.
3. Chọn phiên bản Solidity phù hợp và nhấn "Compile" để biên dịch các contract.

### Bước 3: Triển Khai Contract
1. Chuyển đến tab **Deploy & Run Transactions**.
2. Chọn contract bạn muốn triển khai, bắt đầu với **PlayerManager** và nhấn "Deploy".
3. Tiếp tục triển khai **BetManager**.

---

## 🛠️ Các Chức Năng và Cách Kiểm Tra

### 1. **PlayerManager Contract**

#### **📋 `registerPlayer()`**
- **Mô tả**: Cho phép người chơi đăng ký tài khoản.
- **Cách kiểm tra**: 
  - Sau khi triển khai contract, nhấn vào `registerPlayer()`.
  - Xác nhận giao dịch và kiểm tra tài khoản người chơi mới đã được đăng ký thành công.

#### **💰 `deposit()`**
- **Mô tả**: Nạp tiền vào tài khoản người chơi.
- **Cách kiểm tra**:
  - Sau khi đăng ký, người chơi có thể sử dụng `deposit()` để nạp tiền vào tài khoản của mình.
  - Chọn `deposit()` và nhập số tiền nạp vào. Nhấn "Transact" để gửi giao dịch.

#### **💸 `withdrawBalance(uint256 amount)`**
- **Mô tả**: Cho phép người chơi rút tiền khỏi tài khoản.
- **Cách kiểm tra**:
  - Sau khi đã nạp tiền, sử dụng `withdrawBalance()` để rút tiền.
  - Nhập số tiền cần rút và gửi giao dịch.

#### **🔍 `getBalance(address player)`**
- **Mô tả**: Trả về số dư tài khoản của người chơi.
- **Cách kiểm tra**:
  - Nhập địa chỉ ví của người chơi vào ô `player` và nhấn "Call" để xem số dư.

### 2. **BetManager Contract**

#### **🎲 `placeBet(uint8 betType, uint256 betValue, uint256 betAmount)`**
- **Mô tả**: Đặt cược vào một trò chơi với các tham số `betType`, `betValue` và `betAmount`.
- **Cách kiểm tra**:
  - Nhập loại cược (`betType`), giá trị cược (`betValue`), và số tiền cược (`betAmount`).
  - Nhấn "Transact" để gửi giao dịch và kiểm tra xem cược đã được ghi nhận trong hệ thống.

#### **🎡 `spinWheel()`**
- **Mô tả**: Quay bánh xe để tạo ra một kết quả ngẫu nhiên.
- **Cách kiểm tra**:
  - Chủ sở hữu có quyền gọi hàm này để quay bánh xe.
  - Nhấn vào `spinWheel()` và kiểm tra kết quả qua sự kiện `ResultGenerated`.

#### **🏆 `distributeWinnings(uint256 gameID, uint8 result)`**
- **Mô tả**: Phân phối tiền thưởng cho người chơi sau khi có kết quả.
- **Cách kiểm tra**:
  - Sau khi quay bánh xe, hàm này tự động phân phối phần thưởng cho người chơi.
  - Kiểm tra các sự kiện `WinningsDistributed` để xác nhận tiền thưởng đã được phân phối.

#### **👥 `getPlayers(uint256 gameID)`**
- **Mô tả**: Trả về danh sách người chơi tham gia trò chơi có `gameID`.
- **Cách kiểm tra**:
  - Nhập `gameID` vào trường và nhấn "Call" để xem danh sách người chơi tham gia.

---

## 🔥 Kiểm Tra Sự Kiện
Các sự kiện quan trọng sẽ được phát sinh trong quá trình thực hiện các hành động. Bạn có thể xem kết quả trong phần **Logs** của Remix IDE:
- `BetPlaced`: Khi người chơi đặt cược.
- `ResultGenerated`: Khi kết quả của vòng quay được tạo ra.
- `WinningsDistributed`: Khi phần thưởng được phân phối cho người chơi.

---

## 📈 Kết Quả Kiểm Tra
Sau khi thực hiện các hành động, bạn có thể kiểm tra kết quả thông qua:
1. **Biểu đồ giao dịch** trong Remix IDE.
2. **Sự kiện Logs** để theo dõi các sự kiện như cược đã được đặt, kết quả đã được tạo, và tiền thưởng đã được phân phối.

---

## 📜 Kết Luận
Giờ đây, bạn có thể dễ dàng kiểm tra và tương tác với các smart contract **PlayerManager** và **BetManager** của mình! Hãy thử nghiệm các tính năng như đăng ký người chơi, nạp tiền, đặt cược, và phân phối phần thưởng thông qua Remix IDE.

Chúc bạn thành công và khám phá thế giới DeFi một cách dễ dàng và thú vị!

---
