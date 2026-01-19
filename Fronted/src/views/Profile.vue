<template>
  <div class="profile-container">
    <div class="profile-header">
      <div class="user-info">
        <!-- 用户头像 -->
        <div class="avatar">
          <img src="/src/assets/picture/YoyuEN.png" alt="用户头像" />
        </div>
        <!-- 用户信息 -->
        <div class="user-info-content">
          <p>YoyuEN</p>
          <p>15839393171@163.com</p>
        </div>
      </div>
      <!-- 自我介绍 -->
      <div class="user-info-content">
        <p>
          就读于北方民族大学，软件工程专业。
          宁鸣而死，不默而生！
        </p>
      </div>
    </div>
    <div class="profile-content"></div>
  </div>
</template>
<style scoped>
.profile-container {
  width: 100%;
  height: calc(100vh - 80px);
}

.profile-header {
  display: flex;
  align-items: center;
  width: 100%;
  height: 400px;
  background: url("/src/assets/picture/image.png") no-repeat center center;
  background-size: cover;
  padding: 40px;
}

.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  margin-top: 50px;
  margin-left: 50px;
  border: 4px solid white;
}

.avatar img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
}

.user-info {
    display: grid;
    align-items: center;
    width: 20%;
}

.user-info-content {
  margin-top: 20px;
  margin-left: 50px;
}

.user-info-content p {
  font-family: "快看世界体";
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.profile-content {
  margin-top: -50px;
  height: calc(100vh - 350px);
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}
</style>
