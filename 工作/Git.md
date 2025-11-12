



>拉去release分支代码合并到dev分支，并解决冲突

1. 先暂存本地改动代码

   1. ```bash
      E:\项目暂存\silvershare-manage-service\code>git stash
      ```

2. 切换到release分支更新release分支代码,最后再切换到dev分支

   1. ```bash
      git checkout release_20231015new
      ```

   2. ```bash
      git pull
      ```

   3. ```bash
      git checkout dev_20231015_lihao
      ```

3. 合并release分支代码到dev中

   1. ```bash
      git merge release_20231015new
      ```

   2. 然后将打印出来的冲突文件一个一个手动解决

4.  

```bash
E:\项目暂存\silvershare-manage-service\code>git status
On branch dev_20231015_lihao
Your branch is up to date with 'origin/dev_20231015_lihao'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   src/main/java/com/fuzhihui/manage/dto/business/care_institution.java
        new file:   src/main/java/com/fuzhihui/manage/dto/business/fee.java
        new file:   src/main/java/com/fuzhihui/manage/dto/business/service.java
        new file:   src/main/java/com/fuzhihui/manage/service/BusinessService.java
        new file:   src/main/java/com/fuzhihui/manage/service/Impl/BusinessServiceImpl.java
        new file:   src/main/java/com/fuzhihui/manage/web/controller/BusinessController.java

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   src/main/java/com/fuzhihui/manage/common/util/PageRuleUtil.java
        modified:   src/main/java/com/fuzhihui/manage/common/util/UserUtil.java
        modified:   src/main/java/com/fuzhihui/manage/dao/mapper/UserMapper.java
        modified:   src/main/java/com/fuzhihui/manage/dto/business/care_institution.java
        modified:   src/main/java/com/fuzhihui/manage/dto/business/fee.java
        modified:   src/main/java/com/fuzhihui/manage/dto/business/service.java
        modified:   src/main/java/com/fuzhihui/manage/dto/user/LoginInfoDTO.java
        modified:   src/main/java/com/fuzhihui/manage/dto/user/LoginUserSessionDTO.java
        modified:   src/main/java/com/fuzhihui/manage/service/BusinessService.java
        modified:   src/main/java/com/fuzhihui/manage/service/Impl/BusinessServiceImpl.java
        modified:   src/main/java/com/fuzhihui/manage/service/Impl/UserServiceImpl.java
        modified:   src/main/java/com/fuzhihui/manage/service/UserService.java
        modified:   src/main/java/com/fuzhihui/manage/web/controller/BusinessController.java
        modified:   src/main/java/com/fuzhihui/manage/web/handler/RequestHandler.java
        modified:   src/main/resources/application-local.yml
        modified:   src/main/resources/mapper/UserMapper.xml


E:\项目暂存\silvershare-manage-service\code>git stash
Saved working directory and index state WIP on dev_20231015_lihao: dbb4125 repair test bug

E:\项目暂存\silvershare-manage-service\code>git checkout release_20231015
Switched to a new branch 'release_20231015'
branch 'release_20231015' set up to track 'origin/release_20231015'.

E:\项目暂存\silvershare-manage-service\code>git pull
remote: Enumerating objects: 18, done.
remote: Counting objects: 100% (18/18), done.
remote: Total 18 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (18/18), 4.51 KiB | 57.00 KiB/s, done.
From codeup.aliyun.com:64169f943fb296b5679454e5/silvershare-manage-service
   8bfbd23..ffb06ae  release_20231015     -> origin/release_20231015
   8bfbd23..a473d1d  dev_20231015_liuming -> origin/dev_20231015_liuming
Updating 8bfbd23..ffb06ae
Fast-forward
 code/pom.xml                                       | 105 +++++++--------------
 .../fuzhihui/manage/web/config/Swagger3Config.java |  64 -------------
 .../manage/web/controller/FileController.java      |  71 ++++++++++++++
 .../manage/web/controller/IndexController.java     |  10 --
 .../fuzhihui/manage/web/vo/result/ResultVO.java    |  25 -----
 code/src/main/resources/application.yml            |   2 +-
 .../manage/WebFrameworkApplicationTests.java       |  27 ------
 7 files changed, 107 insertions(+), 197 deletions(-)
 delete mode 100644 code/src/main/java/com/fuzhihui/manage/web/config/Swagger3Config.java
 create mode 100644 code/src/main/java/com/fuzhihui/manage/web/controller/FileController.java
 delete mode 100644 code/src/main/java/com/fuzhihui/manage/web/vo/result/ResultVO.java
 delete mode 100644 code/src/test/java/com/fuzhihui/manage/WebFrameworkApplicationTests.java

E:\项目暂存\silvershare-manage-service\code>git checkout dev_20231015_lihao
Switched to branch 'dev_20231015_lihao'
Your branch is up to date with 'origin/dev_20231015_lihao'.

E:\项目暂存\silvershare-manage-service\code>git merge release_20231015
Auto-merging code/pom.xml
CONFLICT (content): Merge conflict in code/pom.xml
CONFLICT (modify/delete): code/src/main/java/com/fuzhihui/manage/web/config/Swagger3Config.java deleted in release_20231015 and modified in HEAD.  Version HEAD of code/src/main/java/co
m/fuzhihui/manage/web/config/Swagger3Config.java left in tree.
Auto-merging code/src/main/java/com/fuzhihui/manage/web/controller/IndexController.java
CONFLICT (content): Merge conflict in code/src/main/java/com/fuzhihui/manage/web/controller/IndexController.java
Auto-merging code/src/main/resources/application.yml
CONFLICT (rename/delete): code/src/test/java/com/fuzhihui/manage/WebFrameworkApplicationTests.java renamed to code/src/test/java/com/fuzhihui/manage/service/Impl/IndexServiceTest.java
in HEAD, but deleted in release_20231015.
CONFLICT (modify/delete): code/src/test/java/com/fuzhihui/manage/service/Impl/IndexServiceTest.java deleted in release_20231015 and modified in HEAD.  Version HEAD of code/src/test/jav
a/com/fuzhihui/manage/service/Impl/IndexServiceTest.java left in tree.
Automatic merge failed; fix conflicts and then commit the result.

```



> 
>

```java
liuming
189bd5f2ab45273c550ffede0e0cf103
```



```java
lihao
8d42b0cdd8ffc158bddbbc315f597b63
```



```java
jinbao
28022cf7f82f24dae33bc91d13f07738
```





![image-20231017080519344](https://notes-1307435281.cos.ap-shanghai.myqcloud.com/note/master/202310170805707.png)