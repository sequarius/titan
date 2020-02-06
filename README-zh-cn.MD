# Titan
Titan 是一个可以快速生成Spring 项目基础组件的生成器，通过预制模板可以快速生成DO、DTO、Service、Controller代码

## 当前支持生成技术链
MyBatis
SpringMVC

## 使用方式
### 持久层生成
以MyBatis Generate为基础，通过插件的方式生成预制的Repository及DO。

可以使用MyBatis Generate 支持的任意方式集成，具体步骤：
1. 生成配置可以参考[generatorConfig.xml](https://github.com/sequarius/titan-sample/blob/master/titan-sample-repository/src/main/resources/generatorConfig.xml)

2. 添加配置文件config.properties至resource location，可选配置如下。

``` properties
# 数据库驱动
sequarius.titan.generator.driverClass=com.mysql.cj.jdbc.Driver
# 数据库连接
sequarius.titan.generator.connectionURL=
# 数据库用户
sequarius.titan.generator.userId=root
# 数据库密码
sequarius.titan.generator.password=
# 生成do实体包名
sequarius.titan.generator.domain.package=com.sequarius.titan.sample.domain
# 生成repostory包名
sequarius.titan.generator.repository.package=com.sequarius.titan.sample.repository
# 生成mapper 路径
sequarius.titan.generator.mapper.package=com.sequarius.titan.sample.repository
```

3. 用MyBatis Generate 读取配置文件生成即可。

### 业务层生成方法
业务层主要采用模板引擎进行业务场景
1. 添加生成配置
``` yaml
projectRoot: D:/WorkSpace/titan-sample/titan-sample-system # 生成根项目路径(必填)
basePackageName: com.sequarius.titan.sample                # 基础包名称（必填）
servicePackageName: service                                # service 包名称
domainPackageName: domain                                  # domain 包名称
controllerPackageName: controller                          # controller 包名称
commonPackageName: com.sequarius.titan.sample.common       # common 包位置

moduleName: system                # 所属模块包名称 (必填)
displayName: null                 # 实体显示名称 默认使用表注释
entityName: SysU2                 # 实体名称 默认使用DOName
url:                              # 实体url 默认为 /实体名称
overrideWhenFileExisted: true     # 当存在文件是否覆盖 默认不开启
ignoreController: false           # 不创建 controller
ignoreGetMethod: false            # 不创建获取单个实体的方法
ignoreListMethod:                 # 不创建实体列表的方法
ignoreRemoveMethod: true          # 不创建删除实体的方法
ignoreSaveMethod: true            # 不创建保存实体的方法
ignoreUpdateMethod: false         # 不创建更新的方法
# 具体字段配置
fieldSpecs:
- name: id                        # 字段名称 （必填）
  defaultValue: 13                # 默认值
  displayName: ida                # 显示名,默认使用表注释名
  maxLength: 15                   # 最大长度，默认使用数据库字段上限
  minLength: 14                   # 最小长度
  notNull: false                  # 是否非空，默认为false
  regPatten: xdsjsd               # 正则校验规则，默认不校验
  regPattenMessage: "xds jsd!"    # 正则校验失败返回消息
  requestDTOIgnore: null          # 是否在requestDTO中忽略该字段
  responseDTOIgnore: null         # 是否在responseDTO中忽略该字段
  searchable: null                # 是否为可搜索项，目前仅支持String类型
- name: username
  searchable: true
- name: phoneNumber
  searchable: true
```

2. 引入Titan Generator
``` xml
<dependency>
    <groupId>com.sequarius</groupId>
    <artifactId>titan-generator</artifactId>
    <version>${version}</version>
</dependency>
```

3. 使用后端生成器
使用`TailEndGenerator.generate`方法运行即可完成生成。
``` java
import com.sequarius.generator.common.FreeMarkerSupport;
import com.sequarius.generator.common.GenerateSpec;
import com.sequarius.generator.common.YamlConfigSupport;


import java.io.IOException;
import java.net.URL;
import java.net.URLClassLoader;

public class Sample {

    public static void main(String[] args) throws Exception {
        ClassLoader classLoader = Sample.class.getClassLoader();
        TailEndGenerator.getInstance().generate(classLoader, ${第1步定义的生成模板配置}, ${持久层生成的DO名称});
    }
}
```
