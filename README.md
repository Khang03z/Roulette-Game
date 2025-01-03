Hướng Dẫn Test Smart Contract trên Remix IDE
1. Giới thiệu
Trong hướng dẫn này, chúng ta sẽ kiểm tra hai smart contract của bạn: PlayerManager và BetManager. Các chức năng của chúng sẽ được mô tả chi tiết để bạn có thể kiểm tra chúng dễ dàng trên Remix IDE.

2. Các chức năng của PlayerManager Contract
Smart contract PlayerManager quản lý các chức năng liên quan đến người chơi như đăng ký, nạp tiền, rút tiền, và kiểm tra số dư của người chơi.

Hàm: registerPlayer()
Mô tả: Hàm này cho phép người chơi đăng ký tài khoản trong hệ thống.
Cách kiểm tra:
Mở Remix IDE, vào tab "Solidity Compiler" và biên dịch PlayerManager.sol.
Vào tab "Deploy & Run Transactions" và chọn PlayerManager.
Trong phần "Deployed Contracts", nhấn vào registerPlayer().
Gửi giao dịch và kiểm tra nếu người chơi đã được đăng ký thành công.
Hàm: deposit()
Mô tả: Hàm này cho phép người chơi nạp tiền vào tài khoản của mình.
Cách kiểm tra:
Sau khi người chơi đã đăng ký, sử dụng deposit() để nạp tiền vào tài khoản.
Chọn deposit() và nhập số tiền cần nạp.
Nhấn "Transact" và xác nhận giao dịch.
Hàm: withdrawBalance(uint256 amount)
Mô tả: Cho phép người chơi rút một số tiền nhất định từ tài khoản của mình.
Cách kiểm tra:
Sau khi người chơi đã nạp tiền, sử dụng withdrawBalance() để rút tiền.
Nhập số tiền muốn rút và gửi giao dịch.
Hàm: getBalance(address player)
Mô tả: Hàm này trả về số dư của một người chơi cụ thể.
Cách kiểm tra:
Nhập địa chỉ của người chơi vào trường player.
Chọn getBalance và nhấn "Call" để xem số dư của người chơi.
3. Các chức năng của BetManager Contract
Smart contract BetManager quản lý các cược của người chơi, tính toán kết quả và phân phối tiền thưởng.

Hàm: placeBet(uint8 betType, uint256 betValue, uint256 betAmount)
Mô tả: Người chơi có thể đặt cược vào trò chơi, chỉ định loại cược (betType), giá trị cược (betValue), và số tiền cược (betAmount).
Cách kiểm tra:
Trong Remix, sau khi triển khai contract, nhập loại cược (betType), giá trị cược (betValue), và số tiền cược (betAmount).
Nhấn vào placeBet và xác nhận giao dịch.
Kiểm tra nếu cược đã được ghi nhận trong hệ thống.
Hàm: spinWheel()
Mô tả: Chủ sở hữu có thể quay bánh xe để tạo ra một kết quả ngẫu nhiên.
Cách kiểm tra:
Chỉ chủ sở hữu mới có quyền sử dụng hàm này.
Chủ sở hữu gọi hàm spinWheel() để quay bánh xe và tạo kết quả.
Kiểm tra kết quả của vòng quay qua sự kiện ResultGenerated.
Hàm: distributeWinnings(uint256 gameID, uint8 result)
Mô tả: Sau khi có kết quả của trò chơi, hàm này sẽ phân phối tiền thưởng cho người chơi dựa trên kết quả cược của họ.
Cách kiểm tra:
Sau khi quay bánh xe, hàm này sẽ tự động được gọi để phân phối tiền thưởng cho người chơi.
Kiểm tra các sự kiện WinningsDistributed để xác nhận tiền thưởng đã được phân phối.
Hàm: getPlayers(uint256 gameID)
Mô tả: Trả về danh sách người chơi tham gia vào một trò chơi cụ thể.
Cách kiểm tra:
Nhập gameID vào trường và nhấn "Call" để nhận danh sách người chơi.
4. Kiểm tra bằng Remix IDE
Mở Remix IDE:

Truy cập Remix IDE.
Vào tab "Solidity Compiler", chọn phiên bản Solidity phù hợp, và biên dịch các contract của bạn (PlayerManager.sol, BetManager.sol).
Triển khai Contract:

Chuyển đến tab "Deploy & Run Transactions".
Chọn PlayerManager và BetManager trong danh sách contract đã biên dịch và nhấn "Deploy".
Gửi Giao Dịch:

Sau khi triển khai contract, bạn sẽ thấy chúng dưới mục "Deployed Contracts".
Các hàm sẽ hiển thị dưới các contract đã triển khai.
Bạn có thể tương tác với các hàm như placeBet, deposit, withdrawBalance, v.v.
Xem Các Sự Kiện:

Các sự kiện như BetPlaced, ResultGenerated, WinningsDistributed sẽ được hiển thị trong phần "Logs" dưới mỗi giao dịch. Đây là nơi bạn có thể kiểm tra kết quả các hành động đã thực hiện.