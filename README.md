user for alipay,wxpay,unionPay and selfAppPay

本项目致力于简化第三方支付的集成和使用,并且将自有支付和三方支付进行整合和优化,使用起来方便快捷,具体使用请见简书 http://www.jianshu.com/p/26cdb4f42050

# ECPay

1,将文件夹引入工程
  1.1  Build Phases -- Complile Sources 添加文件夹中的.m文件
  1.2  Build Phases -- Link Binary With Libraries 添加文件夹中的第三方库,并引入系统库 SystemConfiguration.framework
  1.3  Build Settings -- Header Search Paths 添加AlipayFiles所在相对路径,例如 :$(SRCROOT)/ECPay/ECPay/Frameworks/AliPay/AlipayFiles 
  1.4 关闭bitcode
  1.5 添加libsqlite3.tbd , libz.tbd,core 和 motion.framework

