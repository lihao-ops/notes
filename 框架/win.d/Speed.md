# Speed系统



## 一、总体介绍

### 1.系统

​	顾名思义，speed系统追求的目标就是快速。

​	它是一种提供金融市场**行情指标数据的服务**以及**行情展示系统**，包含客户端和服务端。







### 2.服务端系统

行情指标服务，是提供金融市场**实时行情指标及历史行情**数据的服务系统。

包含子服务：`SPEED_TICK`,`SPEED_HIS`,`SOURCE_SERVER`







### 3.客户端系统

行情图形框架：是提供以图形方式展示行情数据的客户端系统。







### 4.行情指标

是对金融市场上各种数据的一种命令和编号。命名是市场约定俗成的，编号是公司内部定义的。

涉及的品种范围：

​	股票、指数、基金、债券、期货、期权、外汇，利率。




> 指标定义表(部分)

| 编号           | 中文名     | 英文缩写     | 单位   | 显示格式                                                     | 说明                                                         |
| -------------- | ---------- | ------------ | ------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1 (0x001)      | 交易日期   | TradeDate    |        | yyyy-mm-dd, etc                                              |                                                              |
| 2 (0x002)      | 交易时间   | TradeTime    | 秒     | hh:nn:ss                                                     |                                                              |
| **3  (0x003)** | **最新价** | **NewPrice** | **元** | **小数点后有效位数与品种相关**  **A****股：2位**  **港股：3位或2位(与价差相关)**  **封闭基金、权证：3位**  **开放式基金：4位**  **债券：4位**  **指数：2位；中债指数(.CS)：4位**  **外汇：4位**  **期货：2位** | **编码：v \*  price_unit; price_unt与品种相关**  **显示颜色：**  **if v > prevclose then draw** **涨**  **if v < prevclose then draw** **跌**  **if v == prevclose then draw** **平** |
| 4 (0x004)      | 前收价     | PrevClose    | 元     |                                                              | 同3                                                          |
| 5 (0x005)      | 开盘价     | TodayOpen    | 元     |                                                              | 同3                                                          |
| 6 (0x006)      | 最高价     | TodayHigh    | 元     |                                                              | 同3                                                          |
| 7 (0x007)      | 最低价     | TodayLow     | 元     |                                                              | 同3                                                          |
| 8 (0x008)      | 总成交量   | Volume       | 股     | A股：显示手(百股)  港股：显示手(百股)  指数： 显示手         | .CFE,.SHF,.DCE,.CZC: /100得到交易所最小成交量   其它：最小成交单位股， 股票：股 / 债券为元 |
| 9 (0x009)      | 现额       | DeltaAmount  | 元     |                                                              | .CFE,.SHF,.DCE,.CZC: /10 为元  其它所有： 元                 |
| 10 (0x00A)     | 现量       | DeltaVolume  | 股     |                                                              | .CFE,.SHF,.DCE,.CZC: /100得到交易所最小成交量   其它：最小成交单位股， 股票：股 / 债券为元 |
| 11 (0x00B)     | 买1价      | BidPrice1    | 元     |                                                              | 同3                                                          |
| 12 (0x00C)     | 买2价      | BidPrice2    | 元     |                                                              | 同3                                                          |
| 13 (0x00D)     | 买3价      | BidPrice3    | 元     |                                                              | 同3                                                          |
| 14 (0x00E)     | 买4价      | BidPrice4    | 元     |                                                              | 同3                                                          |
| 15 (0x00F)     | 买5价      | BidPrice5    | 元     |                                                              | 同3                                                          |
| 16 (0x010)     | 买6价      | BidPrice6    | 元     |                                                              | 同3                                                          |
| 17 (0x011)     | 买7价      | BidPrice7    | 元     |                                                              | 同3                                                          |
| 18 (0x012)     | 买8价      | BidPrice8    | 元     |                                                              | 同3                                                          |
| 19 (0x013)     | 买9价      | BidPrice9    | 元     |                                                              | 同3                                                          |
| 20 (0x014)     | 买10价     | BidPrice10   | 元     |                                                              | 同3                                                          |









```txt
目    录

1	SPEED指标定义表	2







 
 
1	指标定义表
编号	中文名	英文缩写	单位	显示格式	说明
1 (0x001)	交易日期	TradeDate		yyyy-mm-dd, etc	
2 (0x002)	交易时间	TradeTime	秒	hh:nn:ss	
3 (0x003)	最新价	NewPrice	元	小数点后有效位数与品种相关
A股：2位
港股：3位或2位(与价差相关)
封闭基金、权证：3位
开放式基金：4位
债券：4位
指数：2位；中债指数(.CS)：4位
外汇：4位
期货：2位	编码：v * price_unit; price_unt与品种相关
显示颜色：
if v > prevclose then draw 涨
if v < prevclose then draw 跌
if v == prevclose then draw 平
4 (0x004)	前收价	PrevClose	元		同3
5 (0x005)	开盘价	TodayOpen	元		同3
6 (0x006)	最高价	TodayHigh	元		同3
7 (0x007)	最低价	TodayLow	元		同3
8 (0x008)	总成交量	Volume	股	A股：显示手(百股)
港股：显示手(百股)
指数： 显示手	.CFE,.SHF,.DCE,.CZC: /100得到交易所最小成交量 
其它：最小成交单位股， 股票：股 / 债券为元
9 (0x009)	现额	DeltaAmount	元		.CFE,.SHF,.DCE,.CZC: /10 为元
其它所有： 元
10 (0x00A)	现量	DeltaVolume	股		.CFE,.SHF,.DCE,.CZC: /100得到交易所最小成交量 
其它：最小成交单位股， 股票：股 / 债券为元
11 (0x00B)	买1价	BidPrice1	元		同3
12 (0x00C)	买2价	BidPrice2	元		同3
13 (0x00D)	买3价	BidPrice3	元		同3
14 (0x00E)	买4价	BidPrice4	元		同3
15 (0x00F)	买5价	BidPrice5	元		同3
16 (0x010)	买6价	BidPrice6	元		同3
17 (0x011)	买7价	BidPrice7	元		同3
18 (0x012)	买8价	BidPrice8	元		同3
19 (0x013)	买9价	BidPrice9	元		同3
20 (0x014)	买10价	BidPrice10	元		同3
21 (0x015)	卖1价	AskPrice1	元		
22 (0x016)	卖2价	AskPrice2	元		
23 (0x017)	卖3价	AskPrice3	元		
24 (0x018)	卖4价	AskPrice4	元		
25 (0x019)	卖5价	AskPrice5	元		
26 (0x01A)	卖6价	AskPrice6	元		
27 (0x01B)	卖7价	AskPrice7	元		
28 (0x01C)	卖8价	AskPrice8	元		
29 (0x01D)	卖9价	AskPrice9	元		
30 (0x01E)	卖10价	AskPrice10	元		
31 (0x01F)	买1量	BidVolume1	股		同3
32 (0x020)	买2量	BidVolume2	股		同3
33 (0x021)	买3量	BidVolume3	股		同3
34 (0x022)	买4量	BidVolume4	股		同3
35 (0x023)	买5量	BidVolume5	股		同3
36 (0x024)	买6量	BidVolume6	股		Level2, 同3
37 (0x025)	买7量	BidVolume7	股		Level2,同3
38 (0x026)	买8量	BidVolume8	股		Level2,同3
39 (0x027)	买9量	BidVolume9	股		Level2,同3
40 (0x028)	买10量	BidVolume10	股		Level2,同3
41 (0x029)	卖1量	AskVolume1	股		
42 (0x02A)	卖2量	AskVolume2	股		
43 (0x02B)	卖3量	AskVolume3	股		
44 (0x02C)	卖4量	AskVolume4	股		
45 (0x02D)	卖5量	AskVolume5	股		
46 (0x02E)	卖6量	AskVolume6	股		Level2, 同3
47 (0x02F)	卖7量	AskVolume7	股		Level2, 同3
48 (0x030)	卖8量	AskVolume8	股		Level2, 同3
49 (0x031)	卖9量	AskVolume9	股		Level2, 同3
50 (0x032)	卖10量	AskVolume10	股		Level2, 同3
51 (0x033)	最优买价	BestBid	元		PriceUnit同3
52 (0x034)	最优卖价	BestAsk	元		PriceUnit同3
53 (0x035)	最小价差	SpreadPrice	元		PriceUnit=1000;
54 (0x036)	外盘	TotalBidVolume	股		成交量的买卖盘
55 (0x037)	内盘	TotalAskVoume	股		成交量的买卖盘
56 (0x038)	当比成交方向	DealDirection			PriceUnit=1; 
和DeltaVolume在一个包发送过来，事务
=0 为买盘成交； =1 为卖盘成交
57 (0x039)	经纪商队列Ask	BrokerQueueAsk			特殊编码
58 (0x03A)	经纪商队列Bid	BrokerQueueBid			特殊编码
59 (0x03B)	总成交额	TotalAmount	元		.CFE,.SHF,.DCE,.CZC: /10  为元
其它所有： 元
60 (0x03D)	成交序列号	DealNo		无单位	
61 (0x03D)	买盘经纪商数1	BidOrdersNo1	个		Priceunit=1
62 (0x03E)	买盘经纪商数2	BidOrdersNo2	个		Priceunit=1
63 (0x03F)	买盘经纪商数3	BidOrdersNo3	个		Priceunit=1
64 (0x040)	买盘经纪商数4	BidOrdersNo4	个		Priceunit=1
65 (0x041)	买盘经纪商数5	BidOrdersNo5	个		Priceunit=1
66 (0x042)	卖盘经纪商数1	AskOrdersNo1	个		Priceunit=1
67 (0x043)	卖盘经纪商数2	AskOrdersNo2	个		Priceunit=1
68 (0x044)	卖盘经纪商数3	AskOrdersNo3	个		Priceunit=1
69 (0x045)	卖盘经纪商数4	AskOrdersNo4	个		Priceunit=1
70 (0x046)	卖盘经纪商数5	AskOrdersNo5	个		Priceunit=1
71 (0x047)	分时成交总笔数	TransactionsCount	笔		Uint32, 分时成交笔数
不是逐笔成交笔数
72 (0x048)	每手股数	LotSize	个		
73 (0x049)	按盘价	DealPrice	元		同3
74 (0x04A)	结算价	Settle	元		同3
75 (0x04B)	前结算价	PrevSettle	元		同3
76 (0x04C)	持仓量	Position			PriceUnit=1
77 (0x04D)	前持仓量	PrevPosition			
78 (0x04E)	持仓量变化	PositionChange			
79 (0x04F)	均价	AveragePrice	元		比最新价的单位多一位；
80 (0x050)	涨跌	Change	元		同3
81 (0x051)	涨跌幅	ChangeRange	%	#0.00	v * 10000
82 (0x052)	5分钟涨跌幅	ChangeRange5Min			
83 (0x53)	前一日收盘价	PrevTodayClose			if 当天无除权, then = PrevClose(4)
84 	最新成交价	LatestPrice	元		如果没有停牌，值等于最新价；停牌的话，等于最近一个交易日的收盘价；
85 (0x55)	5分钟前最新价	ValuePrev5Minutes			计算5分钟涨跌幅用
86	加权平均委买价格	WeightedAverageBestBid	元		SSE Level2: 
87	加权平均委卖价格	WeightedAverageBestAsk	元		SSE Level2: 
88	买卖队列				
89	逐笔成交还原	TransactionRevert			Level2指标：逐笔还原序列
90	逐笔成交序列	Transactions		n/a	Level2指标：逐笔成交序列
91	最优买卖价队列	OrderQueue		n/a	Level指标：最优买卖价上前50委托队列
92	现手笔数	CurrentTransactionCount			Uint32, 现手笔数, = 总笔数(71)增量
93	逐笔委托	L2_Orders			逐笔委托
94	期货成交状态	FUTURES_DEALSTATUS			期货成交状态
1: 空开; 2: 空平; 3: 空换; 4: 多开; 
5: 多平; 6: 多换; 7: 双开; 8: 双平；
95	成交累计标记	TRADE_UPDATE_FLAG			=0，不累计
=3，累计走势及成交明细及分钟K线
=4，只累计成交明细，不累计走势及分钟K线
=7，只累计走势和分钟K线，不累计成交明细
96	成交状态 	TRADE_DEAL_FLAG			‘ ‘, ‘U’
97	交易状态	TradingStatus			PriceUnit=1
=0，无状态/状态未知
=1，正常交易中
=2，休市中/暂停交易
=3，已收盘/当日交易结束
=4，集合竞价中
=5，暂停交易（深交所临时停牌）
=6，科创板正式交易结束
=8，盘前交易 PreMarket
=9,  盘后交易 AfterMarket
=10，期权波动性中断
=11，表示可恢复交易的熔断
=12，表示不可恢复交易的熔断
=19，开市前
=20，冷静期
=88, 已退市
=70, 上网定价发行
=99，停牌

=101，代码无法计算，原因1
=102，代码无法计算，原因2
=103，代码无法计算，原因3
98	结算日期	SettleDate			PriceUnit=1; YYYYMMDD
交易所当地时间
99	分钟数	MinOfDay			从00:00开始的分钟数, =h*60+m
100	秒数	Second			秒数，和99一起决定时间
101	收盘日期	MarketCloseDate			市场收盘日期信号量，YYYYMMDD，
值增加时进行收盘操作
102	逐笔成交时间	L2_TRANSACTION_TIME			HHMMSSXX
103	每手数量	LotNumber			PriceUnit=1
104	最优买价报价
市场编号	BestBidUpdateExchange			PriceUnit=1
105	最优买价更新日期	BestBidUpdateDate			PriceUnit=1;  YYYYMMDD
106	最优买价更新时间	BestBidUpdateTime			PriceUnit=1; HHmmSSss ;  精确到百分之一秒
107	最优卖价报价
市场编号	BestAskUpdateExchange			PriceUnit=1
108	最优卖价更新日期	BestAskUpdateDate			PriceUnit=1;  YYYYMMDD
109	最优卖价更新时间	BestAskUpdateTime			PriceUnit=1; HHmmSSss ;  精确到百分之一秒
110	买盘经纪商数6	BidOrdersNo6	个		Priceunit=1
111	买盘经纪商数7	BidOrdersNo7	个		Priceunit=1
112	买盘经纪商数8	BidOrdersNo8	个		Priceunit=1
113	买盘经纪商数9	BidOrdersNo9	个		Priceunit=1
114	买盘经纪商数10	BidOrdersNo10	个		Priceunit=1
115	卖盘经纪商数6	AskOrdersNo6	个		Priceunit=1
116	买盘经纪商数7	AskOrdersNo7	个		Priceunit=1
117	买盘经纪商数8	AskOrdersNo8	个		Priceunit=1
118	买盘经纪商数9	AskOrdersNo9	个		Priceunit=1
119	买盘经纪商数10	AskOrdersNo10	个		Priceunit=1
120	序列返回开始序号	IND_SeriesStartIndex			QE返回序列的第一条数据的序列号	
121	序列返回结束序号	IND_SeriesEndIndex			QE返回序列的最后一条数据的序列号
122	序列总数	IND_SeriesTotal			QE返回序列值，服务器中的该序列总数
123	波动性中断参考价	AuctionPrice	元		PriceUnit=1000，上交所期权
124	波动性中断集合竞价虚拟匹配量	AuctionQty	份		PriceUnit=1
125 (0x07D)	初始化清除走势、成交明细，指标数据等	InitData			控制指标；初始化内存中指标及当日走势、成交明细数据；
126	昨虚实度	PrevDeltaRation			期货、期权指标
127 (0x07F)	数据包产生时间	ModifyTime		hh:nn:ss	解码格式：ChinaMarketTime；针对港股市场时间无秒；
128	今虚实度	DeltaRatio			期货、期权指标
129	高精度时间	TradeTimeHigh			HHMMSSmmm
130	代码	WindCode			编码：EncodeString
131	中文简称	ShortNameCHS			编码：EncodeString
132	英文简称	ShortNameEng			编码：EncodeString
133	品种类型	SecurityType			=A A股
=B B股
=S 指数
=J 基金
…
134	心跳时间	HeartBeatTime			HHMMSS
135	交易所	Exchange			编码: Int64；交易所编号
请参见交易所编号对照表；
select * from wind.tb_object_0002 order by f9_0002

136	价格单位	PriceUnit			0,1,2,3,4,5,6,7,8 分别代表 1,10,100,1000,10000,100000,1000000,10000000,100000000
应用于价格有效，对成交量、额不处理
137	币种	Currency			Int64，币种编号
0, 原始币种(无币种)
1(CNY,人民币), 2(USD,美元), 3(HKD,港币), 4(TWD,新台币), 5(JPY,日元), 6(EUR，欧元), 7(GBP,英镑), 8(AUD,澳元), 9(CAD,加元), 10(CHF,瑞郎), 11(SGD,新加坡元), 12(MYR,马元), 13(NZD,新西兰元)，14(GBX,便士)
138	开市时间	MarketOpenTime			编码：MinOfDay, Hour*60+Minute，无秒
139	上午休市时间	MarketSuspendTime			编码：MinOfDay
140	下午开市时间	MarketResumeTime			编码：MinOfDay
141	闭市时间	MarketCloseTime			编码：MinOfDay
142	集合竞价时间	PreMarketTime			编码：MinOfDay
143	盘后交易时间	AfterMarketTime			编码：MinOfDay
144	成交类型	DealType			PriceUnit=1
定义：
1: Regular (Short or Long Trade) 常规（多空交易）
2: Regular (Long Trade only - Multiple Sale Condition) 常规（只多交易-多种出价条件）
3: Average Price Trade均价交易
4: Cash Trade (Same Day Clearing)现金交易(当日结算)
5: Automatic Execution自动匹配
6: Intermarket Sweep Order跨市场报价
7: Opening / Reopening Trade Detail开/重开交易细节
8: Intraday Trade Detail盘中交易详情
9: CAP Election Trade CAP选择交易
10: Rule 127 (NYSE only) or Rule 155 (AMEX only) 127规则(NYSE)或者155规则(AMEX)
11: Sold Last (Late Responding)最后出售(延时更新)
12: Next Day Trade (Next Day Clearing) 次日交易(次日结算)
13: Market Center Opening Trade市场中心公开交易
14: Prior Reference Price之前参考价格
15: Seller出售人
16: Extended hours Trade补充交易
17: Extended hours Sold (out of Sequence)补充出售(无序)
18: Sold (Out of Sequence) 出售(无序)
19: Derivatively Priced衍生定价
20: Market Center Reopening Trade市场中心重开交易
21: Market Center Closing Trade市场中心收市交易
145	品种权限标记	AuthValueId			=1，有实时权限
=0，有延时权限
=9, 无权限
146	清盘日期	MarketInitDate			YYYYMMDD，PriceUnit=1
SourceServer在市场清盘时发送，客户端接到后清走势、成交明细等数据；如果已经收到过该值，则忽略。
147	证券竞价状态	TRADING_PHASE_CODE			INT64
0=开市前
1=开盘集合竞价
2=连续竞价阶段
3=盘中临时停牌
4=收盘集合竞价
5=集中竞价闭市
6=协议转让结束
7=闭市
148	证券简称前缀	SecurityPreName			Int64编码
停牌等字符信息, 4位字符串
32位 0xNNNN，每一位都是ASCII
149	成交编号	DealNumber			Int64，
成交编号，从1开始累计
150	行情复权因子序列	HQAFFactors			特殊编码: 日期，值 (priceunit=100000)
151 (0x97)	最新复权因子	HQAFFactor			priceunit = 100000；
如果当天无除权，则 = 0
如果当天除权，则 = 前一天收盘价 / 行情源收到的前收;

计算多日涨跌幅时用
152					
153					
154	序列编号	SeriesIndex			PriceUnit=1
155	事件指标	EventFlags			事件型指标；
156	事件类型				
157	事件ID				
158	事件说明				
159	赎回状态	RedeemStatus			仅针对开放式基金, priceunit=1
=0  无效
=1  开放赎回
=2  暂停赎回
=3  暂停实时赎
160	5日前收盘价	PrevClose5Days	元		复权后；取自1425表
161	10日前收盘价	PrevClose10Days	元		复权后；取自1425表
162	20日前收盘价	PrevClose20Days	元		复权后；取自1425表
163	60日前收盘价	PrevClose60Days	元		复权后；取自1425表
164	120日前收盘价	PrevClose120Days	元		复权后；取自1425表
165	250日前收盘价	PrevClose250Days	元		复权后；取自1425表
166	去年年底收盘价	PrevCloseLastYear	元		复权后；取自1425表
167	发行价格	IPOPrice	元		
168	上市日期	IPODate			
169	最近5日平均量	Last5AV	手		
170	最近30日平均量	Last30AV	手		
171	流通股本	ListedStock	股	显示：万股	股票；
172	总股本	CapitalStock	股	显示：万股	股票；
173	净利润	NetProfits	元		股票；
174	每股收益TTM	EPS_TTM			股票；编码：v * 10000
175	每股收益实际值	EPS_LYR			股票；编码：v * 10000
176	每股收益预测值	EPS_Projected			股票；编码：v * 10000
177	净资产	NetAsset	元		股票；
178	每股净资产	NetAssetPerShare	元		股票；编码：v * 10000
179	总资产	CapitalAsset	元		股票；
180	每股收益预测值2	EPS_Projected2	元		股票；编码: v * 10000
181	市净率	PB			股票；编码：v * 10000
182	市净率LF	PB_LF			股票；编码：v * 10000
183	所属行业	Industry			股票；PriceUnit=1
184	评级	Ratings			股票；编码：v * 100
185	评级机构总数	RatingsInst	个		股票；PriceUnit=1
186	最新年报年份	LYRYear			股票；PriceUnit=1
187	换手率	ChangeHandRate	%	#0.00%	股票；编码：v * 10000
188	量比	LiangBi			股票；编码：v * 10000
189	委比	WeiBi			股票；编码：v * 10000
190	振幅	Fluctuation	%	#0.00%	股票；编码：v * 10000
191	5日涨跌幅	Change5Days	%	#0.00%	股票；
192	10日涨跌幅	Change10Days	%	#0.00%	股票；
193	20日涨跌幅	Change20Days	%	#0.00%	股票；
194	60日涨跌幅	Change60Days	%	#0.00%	股票；
195	120日涨跌幅	Change120Days	%	#0.00%	股票；
196	250日涨跌幅	Change250Days	%	#0.00%	股票；
197	年初至今涨跌幅	ChangeYearBegin	%	#0.00%	股票；
198	总市值	CapitalMarketValue	元	显示#0：亿元，或万元	股票；
199	流通市值 	ListedMarketValue	元	显示#0：亿元，或万元	股票；
200	52周最高	High52Week	元		同3
201	52周最低	Low52Week	元		同3
202	停牌标记	SuspensionFlag			股票；
编码格式：mmddv, mm=month(01-12), dd=day(01-31), 
v=停牌值
=0不停;=1停1h;v=2停2h;=3停半天;=4停下午;
=5半小时;=6临时停牌;=9停牌一天
203	多日涨跌幅计算复权因子	RangeAFFactor			股票；编码：v * 10000
204	新三板允许协议状态	NEEQ_ALLOW_STATUS			PriceUnit=1；新三板适用
=0; 不允许
=1; 允许
205	市盈率TTM	PE_TTM			股票；PriceUnit=10000
206	市盈率LastYear	PE_LYR			股票；PriceUnit=10000
207	市盈率预测	PE_Porjected			股票；PriceUnit=10000
208	市盈率预测值2	PE_Projected2			股票；PriceUnit=10000
209	预估结算价	EstimateSettle			股指期货；同3
210 	日增仓	DailyPositionChange			期货
211	涨停价	HighLimit			股票、权证；同3
212	跌停价	LowLimit			股票、权证；同3
213	委差	Weicha			股票、权证； 214-215
214	最新委买总量	BIDORDER_TOTALVOLUME			股票、权证；
LEVEL-1: 买1量 + .. + 买5量
LEVEL-2: 交易所发送
215	最新委卖总量	ASKORDER_TOTALVOLUME			股票、权证；
LEVEL-1: 卖1量 + .. + 卖5量
LEVEL-2: 交易所发送
216	回收价	WarrentRecoverPrice	元		港股权证；3位
217	上涨家数	UpTotal	个		指数
218	下跌家数	DownTotal	个		指数
219	平盘家数	SameTotal	个		指数
220	市场平均市盈率	PEMA			
221	行业平均市盈率	PEIA			
222	市场平均市净率	PBMA			
223	市场平均市净率	PBIA			
224	AH股对价	AHRatio			只对在A股港股同时上市的A股代码和港股代码有效；
Priceunit=100
225	HA股对价	HARatio			只对在A股港股同时上市的A股代码和港股代码有效；
Priceunit=100
226	认购权证总成交额	CallTurnOver			港股权证指标; 认购权证总成交额 
227	认沽权证总成交额	PutTurnOver			港股权证指标; 认沽权证总成交额
228	正股换手率		%		可转债
229	权证价格				可转债, priceunit = 3
230	最新净值	NetValue	元		基金；编码：v * 10000
231	贴水率	ForwardDiscount	%	#0.00%	基金；编码：v * 10000
232	最新份额
( 发行份额)	FundShares	万份		基金； PriceUnit=1
233	上期净值	PrevNetValue	元		基金；编码：v * 10000
234	最新净值增长率/参考买入汇率(SHSC)	GrowthRate	%	#0.00%	基金；编码：v * 10000
235	年初以来净值增长率/参考卖出汇率(SHSC)	GrowthRateThisYear	%	#0.00%	基金；编码：v * 10000
236	成立以来净值增长率/参考中间汇率(SHSC)	GrowthRateFromDay1	%	#0.00%	基金；编码：v * 10000
237	最近一周净值增长率/结算买入汇率(SHSC)	GrowthRateLastWeek	%	#0.00%	基金；编码：v * 10000
238	最近一月净值增长率/结算卖出汇率(SHSC)	GrowthRateLastMonth	%	#0.00%	基金；编码：v * 10000
239	最近一季净值增长率/结算中间汇率(SHSC)	GrowthRateLastSeason	%	#0.00%	基金；编码：v * 10000
240	最近6月净值增长率	GrowthRateLast6Months	%	#0.00%	基金；编码：v * 10000
241	最近一年净值增长率	GrowthRateLastYear	%	#0.00%	基金；编码：v * 10000
242	平均年化收益率	AverateYearlyYield	%	#0.00%	基金；编码：v * 10000
243	最近累计净值	AccumulatedNetValue	元		基金；编码：v * 10000
244	累计分红	AccumulatedBonus	元		基金；编码：v * 10000
245	管理公司	ManagementCompany			基金；编号
246	昨IPOV值	LastIOPV	元		基金；编码：v * 10000
247	基金仓位	FundPosition	%		Priceunt=10000
248	PV涨跌	PVChange			ETF/LOF基金； v * 10000
249	PV涨跌幅	PVChangeRange	%	#0.00%	ETF/LOF基金;  v * 10000
250	申购状态	SubscriptionStatus			仅对开放式基金有效。Priceunit=1
=0 无效,
=1开放申购 
=2 封闭期
=3 暂停申购
=4 暂停大额申购
=5 暂停定期定额申购
=6 暂停大额定期定额申购
=7 暂停大额申购，暂停定期定额申购
=9未成立
251	溢折价	PremiumDiscount			ETF
252	溢折率	PremiumDiscountRate	%		ETF
253	IOPV	IOPV			ETF
254	时点单位净值	PointNetValue			LOF; PriceUnit=10000
255	时点单位净值涨跌幅	PointNetValueRange	%		LOF; PriceUnit=10000
256	加权价	WeightedPrice			债券；同3
257	全价最新价	FP_NewPrice			债券；同3
258	净价最新价	NP_NewPrice			债券；同3
259	收益率最新价	YTM_NewPrice			债券；同3
260	应计利息	AccruedInterest			债券；PriceUnit=10000
261	到期收益率	YTM			债券；PriceUnit=10000
262	剩余期限	RemainingYears			债券；PriceUnit=10000
263	麦氏久期	MacaulayDuration			债券；PriceUnit=10000
264	修正久期	ModifiedDuration			债券；PriceUnit=10000
265	凸性	Convexity			债券；PriceUnit=10000
266	主体评级
长期信用评级	IssuerCreditRating			债券；PriceUnit=1； 
XXXX YYYY ZZZZ NNNN
值1-9表示A/B/C/D/+/-/1/2/3
267	债券评级
短期信用评级	LatestCreditRating			债券；PriceUnit=1； 
XXXX YYYY ZZZZ NNNN
值1-9表示A/B/C/D/+/-/1/2/3
268	交易市场	Market			债券；PriceUnit=1
269	全价前收价	PrevClose_DP			债券; PriceUnit=10000
270	转股价格	ConversionPrice			可转债; PriceUnit=10000
271	转股比例	ConversionRatio			可转债; PriceUnit=10000
272	转换价值	ConversionValue			可转债；PirceUnit=10000
273	转股溢价率 	OverflowRatio	%		可转债；PriceUnit=10000
274	套利空间	ArbitrageSpace			可转债；PriceUnit=10000
275	剩余流通量(余额)	RemainingCirculation	万元		可转债；PriceUnit=1
276	剩余余额占比	RemainingPercetage	%		权证，剩余流通余额占比; PriceUnit=10000
277	认购权证数量	CallTotal			港股股票下的认购股权证数量；
278	认沽权证数量	PutTotal			港股股票下的认沽股权证数量；
279	购沽成交比	CallPutTurnOverRatio			港股权证指标; PriceUnit=10000
= 认购权证总成交额 / 认沽权证总成交额
280	理论价格	TheoreticalPrice			权证；同3
281	隐含波动率	ImpliedVolatility			权证；同3
282	行权价格	ExercisePrice			权证；同3
283	内在价值	IntrinsicValue			权证；同3
284	时间价值	TimeValue			权证；同3
285	权证溢价率	WarrantOverflowRatio			权证；编码: v * 10000
286	价内外程度	InOut			权证；编码: v * 10000
287	杠杆倍数	LevelTimes			权证；编码: v * 100
288	实际杠杆倍数	ActualLevelTimes			权证；编码: v * 100
289	DELTA	Delta			权证; 编码：v * 10000
290	GAMMA	Gama			权证; 编码：v * 10000
291	VEGA	Vega			权证; 编码：v * 10000
292	THETA	Theta			权证; 编码：v * 10000
293	RHO	RHO			权证; 编码：v * 10000
294	权证类型	WarrantType			权证; PriceUnit=1
295	行权类型	WarrantExerciseType			权证; PriceUnit=1
296	行权方式	WarrantExerciseWay			权证;  1=认购；2=认沽
297	行权比例	WarrantExerciseRatio	%		权证;  PriceUnit=10000
298	到期日/流通总额度(SHSC)	WarrantExerciseDate			权证;  PriceUnit=1
299	正股价格	WarrantStockPrice	元		权证，PriceUnit=4
300	正股涨跌幅	WarrantStockRange	%		权证; PriceUnit=4
301	剩余天数/流通总余额(SHSC)	RemainingDays			权证;  PriceUnit=1
302	行权成本/当日休市状态(SHSC)	ExerciseCost			权证; 
303	权证最后交易日/明日休市状态(SHSC)	WarrantLastTradingDay			权证；日期, PriceUnit=1
304	权证上市数量/当日初始额度(SHSC)	WarrantIssueVolume	份		权证；
305	权证余额/当日剩余额度(SHSC)	WarrantRemainingVolume	份		权证；
306	可转债纯债溢价率	PremiumPB	%		债券；PriceUnit=10000
307	可转债平价/底价(%)	PJDJ	%		债券；PriceUnit=10000
308	可转债类型	ConvertibleBondType			1=偏股, 2=偏债, =3平衡
309	可转债纯债价值				债券，priceunit=10000
310	加权平均价	Weighted_AveragePrice			债券; PriceUnit=100000
311	加权净价	Weighted_NPPrice			债券; PriceUnit=10000
312	加权收益率	Weighted_YTM			债券; PriceUnit=10000
313	前加权价	WeightedPrevClose			债券; PriceUnit=10000
314	前加权净价	WeightedPrev_NPPrice			债券; PriceUnit=10000
315	前加权收益率	WeightedPrev_YTM			债券; PriceUnit=10000
316	开盘价收益率	TodayOpen_YTM			债券, PriceUnit=10000
317	最高价收益率	TodayHigh_YTM			债券, PriceUnit=10000
318	最低价收益率	TodayLow_YTM			债券, PriceUnit=10000
319	利率期限	Term			债券: n1-n2；格式：n1*10000 + n2
320	买入价/点数时间	VBidTime			外汇交易中心外汇; HHMMSS
321	卖出价/远期时间	VAskTime			外汇交易中心外汇; HHMMSS
322	买入掉期点	VBidPricePoint			外汇交易中心外汇；PriceUnit=10000
323	卖出掉期点	VAskPricePoint			外汇交易中心外汇; PriceUnit=10000
324	掉期到期日	SwapDate			外汇交易中心外汇; YYYYMMDD
325	持仓额				PriceUnit=1
326	L2流数据包	L2_StreamPacket			流方式数据包；客户端无需订阅；
327	逐笔成交总笔数	L2_TransactionsCount			
328	逐笔还原总笔数	L2_TransRevertCount			
329	逐笔委托总笔数	L2_OrdersCount			
330		L2_TradeIndex			
331		L2_TradeNumber			
332		L2_TradePrice			
333		L2_TradeQty			
334		L2_TradeSide			
335		L2_BidIndexRef			
336		L2_BidVol			
337		L2_OfferIndexRef			
338		L2_OfferVol			
339		L2_BuyTradeFlag			大单连续成交标识 0 = 开始 1= 结束 2= 中间单  3 = 单笔
340	委托买入总量	L2_TotalBidQty			
341	委卖卖出总量	L2_TotalOfferQty			
342		L2_RevertIndex			还原单成交编号
343		L2_OrderQueue_PriceLevels			
344		L2_OrderQueue_Orders			
345		L2_Order_Side			
346	机构大户买入单总数	L2_Order12_In			
347	机构大户卖出单总数	L2_Order12_Out			
348		L2_SellTradeFlag			大单连续成交标识 0 = 开始 1= 结束 2= 中间单  3 = 单笔
349	当日机构大户净流入占比	L2_MoneyFlow_NetIn_Ratio	%		百分比,printunit=10000
350	逐笔成交总
累计成交量	TransactionsTotalQty			Int64
351	当日机构买入成交量	IND_L2_VOLUME1_IN			
352	当日机构卖出成交量	IND_L2_VOLUME1_OUT			
353	当日大户买入成交量	IND_L2_VOLUME2_IN			
354	当日大户卖出成交量	IND_L2_VOLUME2_OUT			
355	当日中户买入成交量	IND_L2_VOLUME3_IN			
356	当日中户卖出成交量	IND_L2_VOLUME3_OUT			
357	当日散户买入成交量	IND_L2_VOLUME4_IN			
358	当日散户卖出成交量	IND_L2_VOLUME4_OUT			
359	当日机构净买入成交量	IND_L2_VOLUME1_NETIN			
360	当日大户净买入成交量	IND_L2_VOLUME2_NETIN			
361	当日中户净买入成交量	IND_L2_VOLUME3_NETIN			
362	当日散户净买入成交量	IND_L2_VOLUME4_NETIN			
363	当日机构买单总数	Order1_In			
364	当日机构卖单总数	Order1_Out			
365	当日大户买单总数	Order2_In			
366	当日大户卖单总数	Order2_Out			
367	当日中户买单总数	Order3_In			
368	当日中户卖单总数	Order3_Out			
369	当日散户买单总数	Order4_In			
370	当日散户卖单总数	Order4_Out			
371	买单还原编号	BidOrderIndex			
372	卖单还原编号	OfferOrderIndex			
373	历史资金流向MF	L2_MF_DAY			单位%  Σ(大户+机构资金流入量流出量差)/ 流通股本
374	趋势交易发生日	TRENDTRADE_DATE			
375	趋势交易市场形态	TRENDTRADE_MARKETSTATUS			
376	趋势交易买卖信号	TRENDTRADE_SIGNAL			买卖信号
0=无信号, 1=L, 2=L+, 3=S, 4=S+
5=C; 
377	趋势交易顺顶	TRENDTRADE_TOPBAND			
378	趋势交易顺底	TRENDTRADE_TOPBOTTOM			
379	机构资金净流入	L2_MONEY1_NETIN			
380	大户资金净流入	L2_MONEY2_NETIN			
381	中户资金净流入	L2_MONEY3_NETIN			
382	散户资金净流入	L2_MONEY4_NETIN			
383	突破创新高天数	HistoricalHighDays			PriceUnit=1
384	突破高位	HistoricalHighValue			PriceUnit和指标3的一致
385	回档幅度	DownRangeFromHistoricalHigh	%		%, PriceUnit=10000
386	突破时间	HistoricalHighTime			PriceUnit=1，精确到天  YYYYMMDD
387	短线精灵对应指标值	MARKETEVENT_FIELD_VALUE			根据短线精灵EventID，对应的指标值
388	领先指标	领先指标			Priceunit=100
只对 000001.SH和399001.SZ两个代码有效；
389	连红天数	L2_CONT_NETIN_DAYS	天		资金流向指标连续为正的天数，包含今日，如连红3日（含今日），则显示3；若连续流出即连绿3日，则显示-3；
390	1日净流入额	L2_MONEY_1D_NETIN	元		精确到 元
391	1日净流入率	L2_MONEY_1D_NETIN_RATIO	%		今日（机构+大单）买卖股数差/该股流通盘股数
392	5日净流入额	L2_MONEY_5D_NETIN			元；指前4日+今日
393	5日净流入率	L2_MONEY_5D_NETIN_RATIO	%		PriceUnit=10000, 指前4日+今日
394	5日净流入天数	L2_MONEY_5D_NETIN_DAYS	天		统计5日内净流入的天数，如5天内流入为正的天数有3天，则显示3
395	10日净流入额	L2_MONEY_10D_NETIN			
396	10日净流入率	L2_MONEY_10D_NETIN_RATIO	%		
397	10日净流入天数	L2_MONEY_10D_NETIN_DAYS	天		
398	20日净流入额	L2_MONEY_20D_NETIN			
399	20日净流入率	L2_MONEY_20D_NETIN_RATIO	%		
400	20日净流入天数	L2_MONEY_20D_NETIN_DAYS	天		
401	60日净流入额	L2_MONEY_60D_NETIN			
402	60日净流入率	L2_MONEY_60D_NETIN_RATIO	%		
403	60日净流入天数	L2_MONEY_60D_NETIN_DAYS	天		
404	通道持续时间(天数)				PriceUnit=1
405	短线支撑位				PriceUnit同指标3一致
406	距支撑位幅度		%		%, PriceUnit=10000
407	短线阻力位				PriceUnit同指标3一致
408	距阻力位幅度				%, PriceUnit=10000
409	交割月份	DeliveryMonth			期货指标，格式 YYYYMM, PriceUnit=1
410	MACD				Priceunit=100
411	MACD_DIFF				PriceUnit=100
412	KDJ_K				Priceunit=100
413	KDJ_D				Priceunit=100
414	KDJ_J				PriceUnit=100
415	RSI_6				Priceunit=100
416	RSI_12				Priceunit=100
417	SAR				Priceunit=100
418	BOLL_MID				Priceunit=100
419	BOLL_UPPER				Priceunit=100
420	BOLL_LOWER				Priceunit=100
421	5日均线	MA_5			Priceunit as NEWVALUE(3)，前复权
422	10日均线	MA_10			Priceunit as NEWVALUE(3)
423	20日均线	MA_20			Priceunit as NEWVALUE(3)
424	60日均线	MA_60			Priceunit as NEWVALUE(3)
425	120日均线	MA_120			Priceunit as NEWVALUE(3)
426	250日均线	MA_250			Priceunit as NEWVALUE(3)
427	连涨天数		天		Priceunit = 1
428	3日净流入额	L2_MONEY_3D_NETIN	元		PriceUnit=1；指前2日+今日
429	3日净流入率	L2_MONEY_3D_NETIN_RATIO	%		PriceUnit=10000；指前2日+今日
430	BIAS指标	BIAS_5			Priceunit=100
431	CCI指标	CCI_14			Priceunit=100
432	CR指标	CR_26			Priceunit=100
433	PSY指标	PSY_12			Priceunit=100
434	WR指标	WR_10			Priceunit=100
435	B36指标	B36			Priceunit=100
436	AR指标	AR_26			Priceunit=100
437	BR指标	BR_26			Priceunit=100
438	3日净流入天数	L2_MONEY_3D_NETIN_DAYS	天		PriceUnit=1
439	热度	HOTNESS	个		PriceUnit=1, 取值0--5
440	挂单手数	PutOrderTotal			PriceUnit=10000
441	撤单手数	CancelOrderTotal			PriceUnit=10000
442	成交手数	DealOrderTotal			PriceUnit=10000
443	区间流入额	RangeMoneyIn			PriceUnit=10000
444	区间流出额	RangeMoneyOut			PriceUnit=10000
445	低点价	RangeLow			PriceUnit=10000
446	高点价	RangeHigh			PriceUnit=10000
447	欧奈尔相对强度_5	RPS_5			PriceUnit=1000
448	欧奈尔相对强度_20	RPS_20			PriceUnit=1000
449	欧奈尔相对强度_120	RPS_120			PriceUnit=1000
450	欧奈尔相对强度_25	RPS_250			PriceUnit=1000
451	基金投资类型	FundInvestmentType			指标值 '2001010101' 代表含义 '普通股票型基金'
指标值 '2001010102' 代表含义 '被动指数型基金'
指标值 '2001010103' 代表含义 '增强指数型基金'
指标值 '2001010201' 代表含义 '偏股混合型基金'
指标值 '2001010202' 代表含义 '平衡混合型基金'
指标值 '2001010203' 代表含义 '偏债混合型基金'
指标值 '2001010301' 代表含义 '中长期纯债型金'
指标值 '2001010302' 代表含义 '短期纯债型基金'
指标值 '2001010303' 代表含义 '混合债券型一级基金'
指标值 '2001010304' 代表含义 '混合债券型二级基金'
指标值 '2001010400' 代表含义 '货币市场型基金'
指标值 '2001010501' 代表含义 '封闭式基金'
指标值 '2001010502' 代表含义 '保本型基金'
指标值 '2001010503' 代表含义 'QDII基金'
452	未转股比例	ConversionRatio	%		PriceUnit=10000
453	参考证券1价格	RefSec1NewPrice			PriceUnit=主证券的PriceUnit
454	参考证券2价格	RefSec2NewPrice			PriceUnit=主证券的PriceUnit
455	指数样本数量		个		
456	指数样本均价				Priceunit=100
457	指数样本成交金额		亿元		Priceunit=100
458	指数样本平均股本		亿股		Priceunit=100
459	指数样本总市值		亿元		Priceunit=100
460	指数样本总市值占比		%		Priceunit=10000
461	指数样本静态市盈率				Priceunit=100
462	指数级别标识 				无
463	当日机构买入成交额	VIND_L2_AMOUNT1_IN	元		Priceunit=1
464	当日机构卖出成交额	VIND_L2_AMOUNT1_OUT	元		Priceunit=1
465	当日大户买入成交额	VIND_L2_AMOUNT2_IN	元		Priceunit=1
466	当日大户卖出成交额	VIND_L2_AMOUNT2_OUT	元		Priceunit=1
467	当日中户买入成交额	VIND_L2_AMOUNT3_IN	元		Priceunit=1
468	当日中户卖出成交额	VIND_L2_AMOUNT3_OUT	元		Priceunit=1
469	当日散户买入成交额	VIND_L2_AMOUNT4_IN	元		Priceunit=1
470	当日散户卖出成交额	VIND_L2_AMOUNT4_OUT	元		Priceunit=1
471	1分钟涨跌幅	VChangeRange1Min			PriceUnit=10000
472	3分钟涨跌幅	VchangeRange3Min			PriceUnit=10000
473	基差	VSpread	点		PriceUnit=100；
股指期货指标;
474	相对大盘涨跌幅	CompareRange			%, PriceUnit=10000
涨跌幅 – 大盘(000001.SH)涨跌幅
475	热点题材指标	TopicHot			Stream化指标
476	龙头股表现(涨跌幅)	TopMemberChange	%		%, PriceUnit=10000
477	平均涨跌幅	AverageMemberChange	%		%, PriceUnit=10000
478	追踪天数	DaysTotalFollowed	天		PriceUnit=1
479	题材影响力	TopicInfluence			PriceUnit=1, 
1,2,3,4,5
480	热点题材标题	TopicTitle			String
481	板块成份股总数	SectorMemberTotal			个数, PriceUnit=1
482	上涨家数占比	UpStocksPercentage			%, PriceUnit=10000 
483	涨停个股数	TopLimitStocksTotal			个数，PriceUnit=1, 
484	跌停个股数	BottomLimitStocksTotal			个数，PriceUnit=1
485	Top28名涨跌幅	Top28StockRange			%, PriceUnit=10000
(881001.WI)
486	Bottom28名涨跌幅	Bottom28StockRange			%, PriceUnit=10000
(881001.WI)
487	债券期限	Maturity			PriceUnit=10000;
期限3年 = 30000
期限5.5年 = 55000
488	策略交易信号日期				YYYYMMDD, priceunit=1
489	策略交易信号时间				HHMMSS, priceunit=1
490	策略交易信号				0=无信号；
1=多开；2=空开；3=多平；4=空平
Priceunit=1
491	1分钟相对涨跌幅	RelativeRange_1Min	%		%, PriceUnit=10000
1分钟涨跌幅 – 大盘(000001.SH)1分钟涨跌幅
492	3分钟相对涨跌幅	RelativeRange_3Mins	%		%, PriceUnit=10000
3分钟涨跌幅 – 大盘(000001.SH)3分钟涨跌幅
493	5分钟相对涨跌幅	RelativeRange_5Mins	%		%, PriceUnit=10000
5分钟涨跌幅 – 大盘(000001.SH)5分钟涨跌幅
494	15分钟相对涨跌幅	RelativeRange_15Mins	%		%, PriceUnit=10000
15分钟涨跌幅 – 大盘(000001.SH)15分钟涨跌幅
495	30分钟相对涨跌幅	RelativeRange_30Mins	%		%, PriceUnit=10000
15分钟涨跌幅 – 大盘(000001.SH)15分钟涨跌幅
496	区间涨跌幅	Range_BetweenTimes	%		%, PriceUnit=10000
区间由客户端请求时传入，该指标无需订阅
497	上一时刻总成交量	PreviousTotalVolume			PriceUnit=1
QE请求返回时用，客户端无需订阅
498	上一时刻总成交额	PreviousTotalAmount			PriceUnit=1
QE请求返回时用，客户端无需订阅
499	ABPriceRatio	A股B股实时对价			
500	BAPriceRatio	B股A股实时对价			
501	牛证数量	WarrentBullTotal	个		港股指标，PriceUnit=1
502	熊证数量	WarrantBearTotal	个		港股指标，PriceUnit=1
503	距回收价	WarrantPriceDiff			港股指标，PriceUnit=3,
=NewValue – 回收价
504	开盘价全价	TodayOpen_DP			PriceUnit=10000
505	开盘价净价	TodayOpen_NP			PriceUnit=10000
506	最高价全价	TodahHigh_DP			PriceUnit=10000
507	最高价净价	TodayHigh_NP			PriceUnit=10000
508	最低价全价	TodayLow_DP			PriceUnit=10000
509	最低价净价	todayLow_NP			PriceUnit=10000
510	净价前收价	PrevClose_NP			PriceUnit=10000
511	收益率前收价	PrevClose_YTM	%		PriceUnit=10000
512	均价收益率	AveragePriceYTM	%		PriceUnit=10000
513	当期票息	CurrentCoupon	%		PriceUnit=10000
514	最新收益率BP	YTMBP	BP		PriceUnit=100
515	5日收益率BP	YTM5_BP	BP		PriceUnit=100
516	10日收益率BP	YTM10_BP	BP		PriceUnit=100
517	20日收益率BP	YTM20_BP	BP		PriceUnit=100
518	60日收益率BP	YTM60_BP	BP		PriceUnit=100
519	120日收益率BP	YTM120_BP	BP		PriceUnit=100
520	250日收益率BP	YTM250_BP	BP		PriceUnit=100
521	买1价收益率
(最优买收益率)	BidPrice1YTM	%		PriceUnit=10000
522	买2价收益率	BidPrice2YTM	%		PriceUnit=10000
523	买3价收益率	BidPrice3YTM	%		PriceUnit=10000
524	买4价收益率	BidPrice4YTM	%		PriceUnit=10000
525	买5价收益率	BidPrice5YTM	%		PriceUnit=10000
526	买6价收益率	BidPrice6YTM	%		PriceUnit=10000
527	买7价收益率	BidPrice7YTM	%		PriceUnit=10000
528	买8价收益率	BidPrice8YTM	%		PriceUnit=10000
529	买9价收益率	BidPrice9YTM	%		PriceUnit=10000
530	买10价收益率	BidPrice10YTM	%		PriceUnit=10000
531	卖1价收益率
(最优卖收益率)	AskPrice1YTM	%		PriceUnit=10000
532	卖2价收益率	AskPrice2YTM	%		PriceUnit=10000
533	卖3价收益率	AskPrice3YTM	%		PriceUnit=10000
534	卖4价收益率	AskPrice4YTM	%		PriceUnit=10000
535	卖5价收益率	AskPrice5YTM	%		PriceUnit=10000
536	卖6价收益率	AskPrice6YTM	%		PriceUnit=10000
537	卖7价收益率	AskPrice7YTM	%		PriceUnit=10000
538	卖8价收益率	AskPrice8YTM	%		PriceUnit=10000
539	卖9价收益率	AskPrice9YTM	%		PriceUnit=10000
540	卖10价收益率	AskPrice10YTM	%		PriceUnit=10000
541	债券市价成交时间	BondTradeTime			债券，HHMMSS, PriceUnit=1
542	债券市价最新价	BondNewValue			债券，PriceUnit=10000
543	债券市价现手
成交量	BondDeltaVolume			债券，PriceUnit=1，单位股
544	债券市场
总成交量	BondTotalVolume			债券，PriceUnit=1,单位股
545	港股美股对价	HUPriceRatio			PriceUnit=100, 精确到n.nn
546	美股港股对价	UHPriceRatio			PriceUnit=100, 精确到n.nn
547	基金整体溢价率	FundOverallPremiumRate	%		PriceUnit=10000
548	基金综合评级	FundRating			基金； ***** = 50, ****.=45, ****=40
注：支持4星半=45
549	晨星基金评级	MorningstarFundRating			基金； ***** = 50, ****.=45, ****=40
注：支持4星半=45
550	Wind基金评级	WindFundRating			基金； ***** = 50, ****.=45, ****=40
注：支持4星半=45
551	最近2年净值增长率	GrowthRateLast2Years	%	#0.00%	基金；编码：v * 10000
552	最近3年净值增长率	GrowthRateLast3Years	%	#0.00%	基金；编码：v * 10000
553	最近5年净值增长率	GrowthRateLast5Years	%	#0.00%	基金；编码：v * 10000
554	基金规模	FundScale	元		基金；PriceUnit=1
555	七日年化收益率
(最新)	YearlyYield_7Days	%	#0.00%	货币型基金；PriceUnit=10000
556	万份基金收益
(最新)	EarningsPer10000	元		货币型基金；PriceUnit=10000
557	上期七日年化收益率	YearlyYield_7Days_Last	%		货币型基金；PriceUnit=10000
558	上期万份基金收益	EarningsPer10000_Last	元		货币型基金；PriceUnit=10000
559	最新IOPV净值	IOPV_NetValue	元		IOPV净值；PriceUnit=10000
注：IOPV值(253)精度为3;
560	债券最优报价组合	BondBestBidAskGroup			
561	债券最优买报价	BondBestBidPrice	元		单位：元；PriceUnit=10000
562	债券最优买报价
收益率	BondBestBidYTM			收益率；PriceUnit=10000
563	债券最优买报价
券面总额	BondBestBidAmount	元		单位：元；PriceUnit=1
564	债券最优买报价方	BondBestBidIssuer			String；单独订阅返回0
565	债券最优卖报价	BondBestAskPrice	元		单位：元；PriceUnit=10000
566	债券最优卖报价
收益率	BondBestAskYTM			收益率；PriceUnit=10000
567	债券最优卖报价
券面总额	BondBestAskAmount	元		单位：元；PriceUnit=1
568	债券最优卖报价方	BondBestAskIssuer			String; 单独订阅返回0
569	分钟线技术指标	MinuteKLineTechInd			s_techind_mk
570	开盘价涨跌幅	OpenRange	%		百分比；PriceUnit=10000
571	开盘价涨跌	OpenUpDown			价格；PriceUnit同3指标
572	新三板扩展类型	NEEQExtTypeValue			PriceUnit=1
573	新三板交易类型	NEEQTradeTypeValue			PriceUnit=1
574	新三板大宗交易成交量	NEEQBigDealVolume		股	PriceUnit=1
575	新三板大宗交易成交额	NEEDBigDealAmount		元	PriceUnit=1
576	最近交易状态	LatestTradingStatus			PriceUnit=1
停牌/临时停牌/
578	期权品种成交量	OptionsTotalVolume			PriceUnit=1；该品种标的所有上市期权合约的成交量加总
579	期权品种持仓量	OptionsTotalPosition			PriceUnit=1；该品种标的所有上市期权合约的持仓量加总
580	期权成交量认购认沽比		%		PriceUnit=10000
581	期货日增仓百分比		%		PriceUnit=10000
582	是否注册制	IsRegistration			PriceUnit=1
是否注册制；0:无数据；1:是；2:否
583	是否具有协议控制框架	IsVIE			PriceUnit=1
是否具有协议框架；0:无数据；1:是；2:否
584	是否初期	IsEarlyStage			PriceUnit=1
是否初期状态；0: 无数据；1: 是；2: 否
585	近7日平均成交额	TurnOver7DaysAverage	元		PriceUnit=1
586	机构主买入金额		元		PriceUnit=1
587	大户主买入金额		元		PriceUnit=1
588	中户主买入金额		元		PriceUnit=1
589	散户主买入金额		元		PriceUnit=1
590	机构主买入总量		股		PriceUnit=1
591	大户主买入总量		股		PriceUnit=1
592	中户主买入总量		股		PriceUnit=1
593	散户主买入总量		股		PriceUnit=1
594	机构主卖出金额		元		PriceUnit=1
595	大户主卖出金额		元		PriceUnit=1
596	中户主卖出金额		元		PriceUnit=1
597	散户主卖出金额		元		PriceUnit=1
598	机构主卖出总量		股		PriceUnit=1
599	大户主卖出总量		股		PriceUnit=1
600	中户主卖出总量		股		PriceUnit=1
601	散户主卖出总量		股		PriceUnit=1
602	主买总额		元		PriceUnit=1
603	主买总量		股		PriceUnit=1
604	主卖总额		元		PriceUnit=1
605	主卖总量		股		PriceUnit=1
606	资金流向占比(量)		%		PriceUnit=1
607	资金净流入量		股		PriceUnit=1
608	资金净流入金额		元		PriceUnit=1
609	资金流向占比(金额)		%		PriceUnit=10000;
610	与均值差		差		自定义品种指标；PriceUnit=10000
611	标准偏差		差		自定义品种指标；PriceUnit=10000
612	中间值		差		自定义品种指标；PriceUnit=10000
613	出现概率		%		百分比；PriceUnit=10000
614	均值标准差		差		自定义品种指标；PriceUnit=10000
615	多头主买	NetBullPosition			持仓量；国内期货连续合约；PriceUnit=1
616	空头主买	NetBearPosition			持仓量；国内期货连续合约；PriceUnit=1
617	双头开仓	BullBearPosition			持仓量；国内期货连续合约；PriceUnit=1
618	每日资金持仓	MoneyPosition	元		金额；实时持仓期货; PriceUnit=1
619	最廉券代码数字				PriceUnit=1
国债期货对应银行间债最廉券代码数字，6位数字NNNNNN对应NNNNNN.IB (同639指标)
620	债券估值	BONDVALUATION			债券, PriceUnit=10000
621	历史最近复权因子	LastHQAFFactor			PriceUnit=100000
不包括当天的最近的复权因子
622	L1当日资金流入率		%00		PriceUnit=1000000, 0.0001%
623	L1大买单量		股		PriceUnit=1
624	L1大卖单量		股		PriceUnit=1
625	多空景气度	LSExpectations	%		PriceUnit=10000
626	多头主买比率		%		PriceUnit=10000
627	空头主买比率		%		PriceUnit=10000
628	点数价格				PriceUnit=10000
629	题材龙头股代码	TOP_WINDCODE			String类型，特殊解码;
只在题材对应代码中发布，交易所代码不发
630	期现价差00		元		PriceUnit=10000
631	期现价差01		元		PriceUnit=10000
632	期现价差02		元		PriceUnit=10000
633	IRR00		%		PriceUnit=10000
634	IRR01		%		PriceUnit=10000
635	IRR02		%		PriceUnit=10000
636	最廉指标基差00		元		PriceUnit=10000
637	最廉指标基差01		元		PriceUnit=10000
638	最廉指标基差02		元		PriceUnit=10000
639	最廉券				String类型；特殊解码
640	最廉IRR		%		PriceUnit=10000
641	价差1		元		PriceUnit=10000
642	价差2		元		PriceUnit=10000
643	价差3		元		PriceUnit=10000
644	价差4		元		PriceUnit=10000
645	价差5		元		PriceUnit=10000
646	价差6		元		PriceUnit=10000
647	Level-1当日资金
净买筹额		元		PriceUnit=1
648	Level-1大买筹额		元		PriceUnit=1
649	Level-1大卖筹额		元		PriceUnit=1
650	Level-1中买筹额		元		PriceUnit=1
651	Level-1中卖筹额		元		PriceUnit=1
652	Level-1小买筹额		元		PriceUnit=1
653	Level-1小卖筹额		元		PriceUnit=1
654	Level-1连买天数		天		PriceUnit=1
655	Level-1买入天数		天		PriceUnit=1
656	Level-1 
5日内买入天数		天		PriceUnit=1
657	Level-1 
5日内净买筹额		元		PriceUnit=1
659	Level-1 
5日内净买筹率				PriceUnit=1000000，精确到0.0001%
659	Level-1
20日内买入天数		天		PriceUnit=1
660	Level-1
20日内净买筹额		元		PriceUnit=1
661	Level-1
20日内净买筹率				PriceUnit=1000000，精确到0.0001%
662	Level-1
60日内买入天数		天		PriceUnit=1
663	Level-1
60日内净买筹额		元		PriceUnit=1
664	Level-1
60日内净买筹率				PriceUnit=1000000，精确到0.0001%
665	是否盈利	PROFITABLE			=0: 无数据；=1: 盈利；=2: 未盈利
666	是否存在投票权差异	VOTING_RIGHTS_DIFF			=0: 无数据；=1: 无差异; =2: 存在差异
667	非一字涨停个数	TOPLIMIT2_TOTAL	n/a		PriceUnit=1
668	是否融资标的	CrdBuyUnderlying			PriceUnit=1;
是否融资标的；0: 无数据；1:是；2:否
669	是否融券标的	CrdSellUnderlying			PriceUnit=1;
是否融券标的；0: 无数据；1:是；2:否
670	昨日涨停时间		n/a		PriceUnit=1; HHMMSS
671	昨日涨幅		n/a		PriceUnit=10000;百分比
672	自定义期权策略数据2	IND_USER_DEF_OPTIONS2			自定义期权策略2，负责指标，特殊解码
673	最近1分钟成交额	Turnover_1Min	元		PriceUnit=1
674	最近3分钟成交额	Turnover_3Min	元		PriceUnit=1
675	最近5分钟成交额	Turnover_5Min	元		PriceUnit=1
676	前收YTC/P				债券；PriceUnit=10000
677	开盘价YTC/P				债券；PriceUnit=10000
678	最新价YTC/P				债券；PriceUnit=10000
679	最优买YTC/P				债券；PriceUnit=10000
680	最优卖YTC/P				债券；PriceUnit=10000
681	买一价YTC/P				债券；PriceUnit=10000
682	买二价YTC/P				债券；PriceUnit=10000
683	买三价YTC/P				债券；PriceUnit=10000
684	买四价YTC/P				债券；PriceUnit=10000
685	买五价YTC/P				债券；PriceUnit=10000
686	买六价YTC/P				债券；PriceUnit=10000
687	买七价YTC/P				债券；PriceUnit=10000
688	买八价YTC/P				债券；PriceUnit=10000
689	买九价YTC/P				债券；PriceUnit=10000
690	买十价YTC/P				债券；PriceUnit=10000
691	卖一价YTC/P				债券；PriceUnit=10000
692	卖二价YTC/P				债券；PriceUnit=10000
693	卖三价YTC/P				债券；PriceUnit=10000
694	卖四价YTC/P				债券；PriceUnit=10000
695	卖五价YTC/P				债券；PriceUnit=10000
696	卖六价YTC/P				债券；PriceUnit=10000
697	卖七价YTC/P				债券；PriceUnit=10000
698	卖八价YTC/P				债券；PriceUnit=10000
699	卖九价YTC/P				债券；PriceUnit=10000
700	卖十价YTC/P				债券；PriceUnit=10000
701	买一价YCU				债券；PriceUnit=10000
702	买二价YCU				债券；PriceUnit=10000
703	买三价YCU				债券；PriceUnit=10000
704	买四价YCU				债券；PriceUnit=10000
705	买五价YCU				债券；PriceUnit=10000
706	买六价YCU				债券；PriceUnit=10000
707	买七价YCU				债券；PriceUnit=10000
708	买八价YCU				债券；PriceUnit=10000
709	买九价YCU				债券；PriceUnit=10000
710	买十价YCU				债券；PriceUnit=10000
711	卖一价YCU				债券；PriceUnit=10000
712	卖二价YCU				债券；PriceUnit=10000
713	卖三价YCU				债券；PriceUnit=10000
714	卖四价YCU				债券；PriceUnit=10000
715	卖五价YCU				债券；PriceUnit=10000
716	卖六价YCU				债券；PriceUnit=10000
717	卖七价YCU				债券；PriceUnit=10000
718	卖八价YCU				债券；PriceUnit=10000
719	卖九价YCU				债券；PriceUnit=10000
720	卖十价YCU				债券；PriceUnit=10000
721	最高价YTC/P				债券；PriceUnit=10000
722	最低价YTC/P				债券；PriceUnit=10000
723	加权价YTC/P				债券；PriceUnit=10000
724	上日均价YTC/P				债券；PriceUnit=10000
725	麦氏久期YTC/P				债券；PriceUnit=10000
726	修正久期YTC/P				债券；PriceUnit=10000
727	凸性YTC/P				债券；PriceUnit=10000
728	最新价YCU				债券；PriceUnit=10000
729	最优买价YCU				债券；PriceUnit=10000
730	最优卖价YCU				债券；PriceUnit=10000
731	开盘价YCU				债券；PriceUnit=10000
732	最高价YCU				债券；PriceUnit=10000
733	最低价YCU				债券；PriceUnit=10000
734	前收价YCU				债券；PriceUnit=10000
735	加权价YCU				债券；PriceUnit=10000
736	上日均价YCU				债券；PriceUnit=10000
737	麦氏久期YCU				债券；PriceUnit=10000
738	修正久期YCU				债券；PriceUnit=10000
739	凸性YCU				债券；PriceUnit=10000
740	买价提供者				PriceUnit=1；用于现货或外汇行情，显示为字母对应的ASCII码组合转换
741	卖价提供者				PriceUnit=1；用于现货或外汇行情，显示为字母对应的ASCII码组合转换
742	地区代码				PriceUnit=1
743	城市代码				PriceUnit=1
744	成交市场				PriceUnit=1； 用于综合报价市场行情，市场编号与wind标准一致
745	买价市场				PriceUnit=1；用于综合报价市场行情，市场编号与wind标准一致
746	卖价市场				PriceUnit=1；用于综合报价市场行情，市场编号与wind标准一致
747	最新收益率BP
(YTC/P)				债券；PriceUnit=10000
748	5日收益率BP
(YTC/P)				债券；PriceUnit=10000
749	10日收益率BP
(YTC/P)				债券；PriceUnit=10000
750	20日收益率BP
(YTC/P)				债券；PriceUnit=10000
751	60日收益率BP
(YTC/P)				债券；PriceUnit=10000
752	120日收益率BP
(YTC/P)				债券；PriceUnit=10000
753	250日收益率BP
(YTC/P)				债券；PriceUnit=10000
754	最新收益率BP(YCU)				债券；PriceUnit=10000
755	5日收益率BP(YCU)				债券；PriceUnit=10000
756	10日收益率BP(YCU)				债券；PriceUnit=10000
757	20日收益率BP(YCU)				债券；PriceUnit=10000
758	60日收益率BP(YCU)				债券；PriceUnit=10000
759	120日收益率BP(YCU)				债券；PriceUnit=10000
760	250日收益率BP(YCU)				债券；PriceUnit=10000
761	欧奈尔相对强度_30	RPS_30			PriceUnit=1000
762	欧奈尔相对强度_60	RPS_60			PriceUnit=1000
763	证券交易状态（整手订单）	SecTradingStatus1			=0，无状态/状态未知
=1，限制买入
=2，限制卖出
=3，限制买入卖出
764	证券交易状态（零股订单）	SecTradingStatus2			=0，无状态/状态未知
=1，限制买入
=2，限制卖出
=3，限制买入卖出
765	债券交易成交方向	BOND_TRADE_DIRECTION			CFETS在CMDS接口新增加，PriceUnit=1

766	场外期权报价	OPTIONS_ORDERBOOK			组合流指标
767	品种行情延时标记	DELAY_FLAG			沪港通港股股票专用。
PriceUnit=1
=0，实时
=15，延时15分钟
=60，延时60分钟
=10，延时10分钟
768	新三板做市商家数	NEED_BROKER_TOTAL			新三板; PriceUnit = 1
769	中行外汇组合指标	IND_STREAM_BOC_FX_QUOTE			组合流指标
770	期权总成交量	E_IT_OPTION_TVOLUME			
771	认购成交量	E_IT_OPTION_CALLVOLUME			
772	认沽成交量	E_IT_OPTION_PUTVOLUME			
773	沽购比	E_IT_OPTION_PCRATE			
774	期权总成交额	E_IT_OPTION_TAMOUNT			
775	期权总持仓量	E_IT_OPTION_TPOSITION			
776	买一隐含波动率	E_IT_IMPLIEDVOLATILITY_BID1	%		期权；PriceUnit=10000
777	买二隐含波动率	E_IT_IMPLIEDVOLATILITY_BID2	%		期权；PriceUnit=10000
778	买三隐含波动率	E_IT_IMPLIEDVOLATILITY_BID3	%		期权；PriceUnit=10000
779	买四隐含波动率	E_IT_IMPLIEDVOLATILITY_BID4	%		期权；PriceUnit=10000
780	买五隐含波动率	E_IT_IMPLIEDVOLATILITY_BID5	%		期权；PriceUnit=10000
781	买六隐含波动率	E_IT_IMPLIEDVOLATILITY_BID6	%		期权；PriceUnit=10000
782	买七隐含波动率	E_IT_IMPLIEDVOLATILITY_BID7	%		期权；PriceUnit=10000
783	买八隐含波动率	E_IT_IMPLIEDVOLATILITY_BID8	%		期权；PriceUnit=10000
784	买九隐含波动率	E_IT_IMPLIEDVOLATILITY_BID9	%		期权；PriceUnit=10000
785	买十隐含波动率	E_IT_IMPLIEDVOLATILITY_BID10	%		期权；PriceUnit=10000
786	卖一隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK1	%		期权；PriceUnit=10000
787	卖二隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK2	%		期权；PriceUnit=10000
788	卖三隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK3	%		期权；PriceUnit=10000
789	卖四隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK4	%		期权；PriceUnit=10000
790	卖五隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK5	%		期权；PriceUnit=10000
791	卖六隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK6	%		期权；PriceUnit=10000
792	卖七隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK7	%		期权；PriceUnit=10000
793	卖八隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK8	%		期权；PriceUnit=10000
794	卖九隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK9	%		期权；PriceUnit=10000
795	卖十隐含波动率	E_IT_IMPLIEDVOLATILITY_ASK10	%		期权；PriceUnit=10000
796	权利金	OPTION_BALANCE	元		期权；PriceUnit=100
797	保证金	OPTION_MARGIN	元		期权；PriceUnit=100
798	无风险利率	OPTION_NORISKRAT	%		期权；PriceUnit=10000
799	营业总收入				PriceUnit=1
800	营业总收入增长率		%		PriceUnit=10000
801	营业利润				PriceUnit=1
802	营业利润增长率		%		PriceUnit=10000
803	净利润增长率		%		PriceUnit=10000
804	所属财报年月				PriceUnit=1
805	新三板逐笔委托经纪商编码	NEEQ_Order_BrokerId			PriceUnit=1
806	新三板逐笔委托功能编码	NEEQ_Order_FunctionCode			PriceUnit=1
1=’B’, 2=’S’, 3=’C’
807	新三板逐笔委托状态	NEEQ_Order_Status			
808	新三板逐笔委托	NEEQ_ORDERS			新三板逐笔委托
809	新三板逐笔委托标记	NEEQ_ORDERS_FLAG			
810	盘前最新价	PREMARKET_NEWPRICE			PriceUnit 与指标3(最新价)相等
811	盘前涨跌	PREMARKET_CHANGE			PriceUnit 与指标 80(涨跌) 相等
812	盘前涨跌幅	PREMARKET_CHANGERANGE	%		PriceUnit 与指标81(涨跌幅)相等  = 10000
813	盘前成交量	PREMARKET_VOLUME			PriceUnit 与指标 8(成交量)相等
814	盘后最新价	AFTERMARKET_NEWPRICE			PriceUnit 与指标3(最新价)相等
815	盘后涨跌	AFTERMARKET_CHANGE			PriceUnit 与指标 80(涨跌) 相等
816	盘后涨跌幅	AFTERMARKET_CHANGERANGE	%		PriceUnit 与指标81(涨跌幅)相等  = 10000
817	盘后成交量	AFTERMARKET_VOLUME			PriceUnit 与指标 8(成交量)相等
818	BBQ 收益率	E_IT_BBQYTM			债券；PriceUnit=10000
819	BBQ 成交价	E_IT_BBQLATESTPRICE	BBQ			债券；PriceUnit=10000
820	BBQ 最优买价	E_IT_BBQBONDBESTBIDPRICE			债券；PriceUnit=10000
821	BBQ 最优卖价	E_IT_BBQBONDBESTASKPRICE			债券；PriceUnit=10000
822	BBQ 成交价净价	E_IT_BBQLATESTPRICE_NPPRICE			债券；PriceUnit=10000
823	BBQ 最优买净价	E_IT_BBQBONDBESTBIDPRICE_NPPRICE			债券；PriceUnit=10000
824	BBQ 最优卖净价	E_IT_BBQBONDBESTASKPRICE_NPPRICE			债券；PriceUnit=10000
825	BBQ成交价基差	E_IT_BBQLATESTPRICE_VSPREAD	BBQ			债券；PriceUnit=10000
826	BBQ 最优买基差	E_IT_BBQBONDBESTBIDPRICE_VSPREAD			债券；PriceUnit=10000
827	BBQ 最优卖基差	E_IT_BBQBONDBESTASKPRICE_VSPREAD			债券；PriceUnit=10000
828	BBQ 成交价IRR	E_IT_BBQLATESTPRICE_IRR			债券；PriceUnit=10000
829	BBQ 最优买IRR	E_IT_BBQBONDBESTBIDPRICE_IRR			债券；PriceUnit=10000
830	BBQ 最优卖IRR	E_IT_BBQBONDBESTASKPRICE_IRR			债券；PriceUnit=10000
831	CFETS 最优买净价	E_IT_CFETSBONDBESTBIDPRICE_NPPRICE			债券；PriceUnit=10000
832	CFETS 最优卖净价	E_IT_CFETSBONDBESTASKPRICE_NPPRICE			债券；PriceUnit=10000
833	CFETS 最优买基差	E_IT_CFETSBONDBESTBIDPRICE_VSPREAD			债券；PriceUnit=10000
834	CFETS 最优卖基差	E_IT_CFETSBONDBESTASKPRICE_VSPREAD			债券；PriceUnit=10000
835	CFETS 最优买IRR	E_IT_CFETSBONDBESTBIDPRICE_IRR			债券；PriceUnit=10000
836	CFETS 最优卖IRR	E_IT_CFETSBONDBESTASKPRICE_IRR			债券；PriceUnit=10000
837	港股通当日可用总额	E_IT_HKCONNECT_TOTALAMOUNT			指数；PriceUnit =1
838	港股通当日已用额	E_IT_HKCONNECT_AMOUNTUSED			指数；PriceUnit=1
839	港股通当日剩余可用额	E_IT_HKCONNECT_AMOUNTREMAIN			指数；PriceUnit=1
840	逐笔成交序列2	E_IT_L2_TRANSACTIONS2			Level2指标，逐笔成交序列2
对比90指标，增加成交对应的委买委卖编号
841	持仓额	POSITION_MONEY			商品；PriceUnit=1
元
842	是否BBQ行情	E_IT_ISBBQ			1 收益率，2 最新价 9 bid data) 同 CFETS 分开
843	BBQ交易时间	E_IT_BBQTRADETIME			HHMMss
844	BBQ成交价基差01	E_IT_BBQLATESTPRICE_VSPREAD01			债券；PriceUnit=10000
845	BBQ 成交价基差02	E_IT_BBQLATESTPRICE_VSPREAD02			债券；PriceUnit=10000
846	BBQ 最优买基差01	E_IT_BBQBONDBESTBIDPRICE_VSPREAD01			债券；PriceUnit=10000
847	BBQ 最优买基差02	E_IT_BBQBONDBESTBIDPRICE_VSPREAD02			债券；PriceUnit=10000
848	BBQ 最优卖基差01	E_IT_BBQBONDBESTASKPRICE_VSPREAD01			债券；PriceUnit=10000
849	BBQ 最优卖基差02	E_IT_BBQBONDBESTASKPRICE_VSPREAD02			债券；PriceUnit=10000
850	BBQ 成交价IRR01	E_IT_BBQLATESTPRICE_IRR01			债券；PriceUnit=10000
851	BBQ 成交价IRR02	E_IT_BBQLATESTPRICE_IRR02			债券；PriceUnit=10000
852	BBQ 最优买IRR01	E_IT_BBQBONDBESTBIDPRICE_IRR01			债券；PriceUnit=10000
853	BBQ 最优买IRR02	E_IT_BBQBONDBESTBIDPRICE_IRR02			债券；PriceUnit=10000
854	BBQ 最优卖IRR01	E_IT_BBQBONDBESTASKPRICE_IRR01			债券；PriceUnit=10000
855	BBQ 最优卖IRR02	E_IT_BBQBONDBESTASKPRICE_IRR02			债券；PriceUnit=10000
856	CFETS 最优买基差01	E_IT_CFETSBONDBESTBIDPRICE_VSPREAD01			债券；PriceUnit=10000
857	CFETS 最优买基差02	E_IT_CFETSBONDBESTBIDPRICE_VSPREAD02			债券；PriceUnit=10000
858	CFETS 最优卖基差01	E_IT_CFETSBONDBESTASKPRICE_VSPREAD01			债券；PriceUnit=10000
859	CFETS 最优卖基差02	E_IT_CFETSBONDBESTASKPRICE_VSPREAD02			债券；PriceUnit=10000
860	CFETS 最优买IRR01	E_IT_CFETSBONDBESTBIDPRICE_IRR01			债券；PriceUnit=10000
861	CFETS 最优买IRR02	E_IT_CFETSBONDBESTBIDPRICE_IRR02			债券；PriceUnit=10000
862	CFETS 最优卖IRR01	E_IT_CFETSBONDBESTASKPRICE_IRR01			债券；PriceUnit=10000
863	CFETS 最优卖IRR02	E_IT_CFETSBONDBESTASKPRICE_IRR02			债券；PriceUnit=10000
864	BBQ最优买收益率	E_IT_BBQBESTBID_YTM			债券；PriceUnit=10000
865	BBQ最优卖收益率 	E_IT_BBQBESTASK_YTM			债券；PriceUnit=10000
866	贡献度	E_CONTRIBUTION_TO_MARKET			%,
PriceUnit=10000；相对万得全A

867	5分钟贡献度	E_CONTRIBUTION_TO_MARKET_5MIN			%,
PriceUnit=10000；相对万得全A 881001.WI

868	涨停时间	E_TOUCH_UPPER_LIMIT_TIME			HHMMSS
869	跌停时间	E_TOUCH_LOWER_LIMIT_TIME			HHMMSS
870	债券投资者适当性管理分类信息	E_QUALIFICATIONCLASS			深交所债券，PriceUnit=0
0,1,2；默认0
871	区间成交额	E_RANGE_TOTALAMOUNT			当日区间统计使用，无订阅
872	平盘家数（不含停牌股票）	SAME_TOTAL_EX			PriceUnit=0，家数
873	区间贡献度	E_RANGE_CONTRIBUTION			PriceUnit=10000
874	当日买入	BUY_TURNOVER			港股通指标，单位：元
875	当日卖出	SELL_TURNOVER			港股通指标，单位：元
876	当日总成交	SUM_TURNOVER			港股通指标，单位：元
877	当日净买入	NET_TURNOVER			港股通指标，单位：元
878	总市值2	CAPITAL_VALUE2			总市值2，单位元，PriceUnit=0
879	股息率	DIVIDEND_YIELD			%，PriceUnit=10000,
880	融资余额	IND_RZYE			单位：元
881	融券余额	IND_RQYE			单位：股
882	陆股通持股占流通A股比率	IND_CGZB			单位：% PriceUnit = 10000
883	卖空股数	IND_MKGS			单位：股
884	BBQ最廉券最新价	IND_BBQ_PRICE_BESTCODE_IIR			PriceUnit=10000
885	事件指标	IND_MARKET_EVENT_2			时间指标订阅，特殊推送，增加价格指标单位
886	行情当日历史数据收盘日期	MARKET_CLOSE_ _DATE			YYYYMMDD，PriceUnit=1
SourceServer在市场清盘前一段时间发送该指标，HIS收到到后将内存中的当日走势、成交明细、分钟K线等进行收盘操作。如果已经收到过该值，或者当日已经进行过收盘操作，则忽略。
887	今日拉动指数	IND_CONTRIBUTION			点位；PriceUnit=100；相对万得全A；
计算申万一级行业板块及万得概念板块成份里的指数
888	行情延迟检测指标	DELAY_CHECK			无符号64位整型，PriceUnit=0
889	SourceServer内部使用	SS_RESERVERED			SourceServer内部保留指标
890	TICK服务器延迟检测指标	DELAY_CHECK_TICK			无符号64位整型,TICK检测延迟用，
在SS收到的包时间戳上加入处理解包的时间。
格式：HHMMSSsssDDDD
HHMMSSsss是从SourceServer收到的时间,sss为毫秒
DDDD是TICK处理增加的延迟，单位ms，最大延迟可以到9.999秒(9999毫秒)

891	新三板逐笔委托	IND_NEED_ORDERS_2			新三板委托2，订阅用，增加价格指标单位
892	场外期权报价列表	IND_OTC_OPTIONS_ORDERBOOK_2			场外期权报价，订阅用，增加价格指标单位 
893	自定义期权策略数据	IND_USER_DEF_OPTIONS			自定义期权策略，负责指标，特殊解码
894	贡献度（相对上证综指）	E_CONTRIBUTION_TO_MARKET_000001			%, PriceUnit=10000；
895	贡献度（相对深证综指）	E_CONTRIBUTION_TO_MARKET_399106			%, PriceUnit=10000；
896	贡献度（相对中小板指）	E_CONTRIBUTION_TO_MARKET_399005			%, PriceUnit=10000；
897	贡献度（相对创业板指）	E_CONTRIBUTION_TO_MARKET_399006			%, PriceUnit=10000；
898	开放式基金实时估值	OF_EST_VALUE			PriceUnit=10000
899	成分股停牌个数	E_SUSPENDED_TOTAL			PriceUnit=1
全A，沪A，深A，沪深300，中小板，创业板
900	字符串指标开始				900 --- 1022 为字符串类型指标
901	证券融资融券股港通等标记属性	E_IT_STOCK_ATTR			字符串类型，如600594证券标识内容如下：
融,D46305,FFFFFF|通,D46305,FFFFFF
多个标识以“|”线分隔；每个标识内部字段以“，”分隔，第一个字段代表标识展示文字，第二个字段代表标识背景颜色，第三个字段代表标识文字颜色
902	BBQ 成交价最廉券	E_IT_BBQLATESTPRICE_BESTCODE			String
903	BBQ 最优买最廉券	E_IT_BBQBONDBESTBIDPRICE_BESTCODE			String
904	BBQ 最优卖最廉券	E_IT_BBQBONDBESTASKPRICE_BESTCODE			String
905	CFETS 最优买最廉券	E_IT_CFETSBONDBESTBIDPRICE_BESTCODE			String
906	CFETS 最优卖最廉券	E_IT_CFETSBONDBESTASKPRICE_BESTCODE			String
907	剩余期限				String, 从报表中获取得到；若排序按照
908	基金投资类型				String, 
909					
910	涨跌分布	E_CHANGE_PERCENTAGE_STAT			String，7个部分
涨停,涨跌<v<=5%,5%<v<=1%,1%<v<-1%,
1%<=v<-5%,-5%<=v<跌停,跌停
911	基金管理公司	E_STR_FUND_MAN			String, 
912	所属行业	E_STR_INDUSTRY			String
913	涨跌分布深交所	E_CHANGE_PERCENTAGE_STAT_SZSE			涨停,9%,8%,7%,6%,5%,4%,3%,2%,1%,-1%,-2%,-3%,-4%,-5%,-6%,-7%,-8%,-9%,跌停
914	上一交易日涨跌分布	E_CHANGE_PERCENTAGE_STAT_PREV			涨停,9%,8%,7%,6%,5%,4%,3%,2%,1%,-1%,-2%,-3%,-4%,-5%,-6%,-7%,-8%,-9%,跌停
915	上一交易日涨跌停平家数	E_MARKET_LITMIT_STAT_PREV			String, 4个部分
涨停家数,跌停家数,平盘家数,停牌家数
916	涨跌分布(含ST)				涨停,9%,8%,7%,6%,5%,4%,3%,2%,1%,-1%,-2%,-3%,-4%,-5%,-6%,-7%,-8%,-9%,跌停
917	上一交易日涨跌分布(含ST)				涨停,9%,8%,7%,6%,5%,4%,3%,2%,1%,-1%,-2%,-3%,-4%,-5%,-6%,-7%,-8%,-9%,跌停
918	BBQYieldRateBid				
919	BBQYieldRateOffer				
920	BBQVolumeBid				
921	BBQVolumeOffer				
922	新三板扩展类型	NEEQExtType			扩展类型, [对于全国股转系统股票，是分层信息, 0: 无数据, 1: 基础层, 2: 创新层， 3: 精选层];
923	新三板交易类型
	NEEQTradeType			交易类型, [对于全国股转系统股票，‘T’表示协议交易方式；‘M’表示做市交易方式；‘B’表示集合竞价+连续竞价交易方式；‘C’表示集合竞价交易方式；‘P’表示发行方式，‘O’表示其他类型]
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
991	中行外汇报价字符串，买1/卖1档位	IND_BOCFX_QUOTE1_STRING			字符串指标
992	中行外汇报价字符串，买2/卖2档位	IND_BOCFX_QUOTE2_STRING			字符串指标
993	中行外汇报价字符串，买3/卖3档位	IND_BOCFX_QUOTE3_STRING			字符串指标
					
					
					
					
					
					
1022	字符串指标结束				
1023					
1024	内部使用				内部使用;
1025	成交量_期转现				PriceUnit=1,国债期货 TF,T,TS开头的*.CFE
1026	持仓量_期转现				PriceUnit=1, 国债期货 TF,T,TS开头的*.CFE
1027	盘前成交时间	PREMARKET_TRADE_TIME			HHMMSS
1028	盘后成交时间	AFTERMARKET_TRADE_TIME			HHMMSS
1029	盘前成交现手成交量	PREMARKET_ DELTA_VOLUME	股		
1030	盘后成交现手成交量	AFTERMARKET_ DELTA_VOLUME	股		
1031	买k1价	BidPrice_k1	元		同3
1032	买k2价	BidPrice_k2	元		同3
1032	买k3价	BidPrice_k3	元		同3
1034	买k4价	BidPrice_k4	元		同3
1035	买k5价	BidPrice_k5	元		同3
1036	买k6价	BidPrice_k6	元		同3
1037	买k7价	BidPrice_k7	元		同3
1038	买k8价	BidPrice_k8	元		同3
1039	买k9价	BidPrice_k9	元		同3
1040	买k10价	BidPrice_k10	元		同3
1041	买k11价	BidPrice_k11	元		同3
1042	买k12价	BidPrice_k12	元		同3
1043	买k13价	BidPrice_k13	元		同3
1044	买k14价	BidPrice_k14	元		同3
1045	买k15价	BidPrice_k15	元		同3
1046	买k16价	BidPrice_k16	元		同3
1047	买k17价	BidPrice_k17	元		同3
1048	买k18价	BidPrice_k18	元		同3
1049	买k19价	BidPrice_k19	元		同3
1050	买k20价	BidPrice_k20	元		同3
1051	买k1量	BidVolume_k1	股		
1052	买k2量	BidVolume_k2	股		
1053	买k3量	BidVolume_k3	股		
1054	买k4量	BidVolume_k4	股		
1055	买k5量	BidVolume_k5	股		
1056	买k6量	BidVolume_k6	股		
1057	买k7量	BidVolume_k7	股		
1058	买k8量	BidVolume_k8	股		
1059	买k9量	BidVolume_k9	股		
1060	买k10量	BidVolume_k10	股		
1061	买k11量	BidVolume_k11	股		
1062	买k12量	BidVolume_k12	股		
1063	买k13量	BidVolume_k13	股		
1064	买k14量	BidVolume_k14	股		
1065	买k15量	BidVolume_k15	股		
1066	买k16量	BidVolume_k16	股		
1067	买k17量	BidVolume_k17	股		
1068	买k18量	BidVolume_k18	股		
1069	买k19量	BidVolume_k19	股		
1070	买k20量	BidVolume_k20	股		
1071	复权说明英文	AFCommentEng			字符串，在QE历史复权请求中返回。
不要订阅使用。
1072	千档更新时间	TradeTime_2			HHMMSS；千档更新时间
1073	最新价_2	NewPrice_2			单位1000000 ，6位
1074	前收价_2	PrevClose_2			单位1000000
1075	开盘价_2	TodayOpen_2			单位1000000
1076	最高价_2	TodayHigh_2			单位1000000
1077	最低价_2	TodayLow_2			单位1000000
1078	最优买价_2(买1价2)	BidPrice1_2			单位1000000
1079	最优卖价_2(卖1价2)	AskPrice1_2			单位1000000
1080	结算价_2	SettlePrice_2			单位1000000
1081	前结算价_2	PrevSettle_2			单位1000000 ，6位
1082	均价_2	AveragePrice_2			单位1000000 ，6位
1083	涨跌_2	Change_2			单位 1000000,  6位
1084	涨停价_2	TopLimit_2			单位 1000000,  6位
1085	跌停价_2	BottomLimit_2			单位 1000000,  6位
1086	最新成交价_2	LatestPrice_2			单位 1000000,  6位
1087	昨日流通市值	LISTED_MARKET_VALUE_PREV			单位：元
1088	千档价位订阅推送	HOLO_LEVEL_PRICE			千档价位订阅推送返回指标。
客户端不要订阅这个指标，而是用专用的价位订阅请求；
1089	买盘前20档全景	HOLO_FULL20_BID			特殊指标，二进制流，客户端解码
1090	卖盘前20档全景	HOLO_FULL20_ASK			特殊指标，二进制流，客户端解码
1091	千档买盘明细	HOLO_ORDERS_BID			特殊指标，二进制流，客户端解码
1092	千档卖盘明细	HOLO_ORDERS_ASK			特殊指标，二进制流，客户端解码
1093	千档买盘委托每笔均量				手
1094	千档买盘委托均价				
1095	千档买盘委托总量				
1096	千档买盘总档位数				
1097	千档卖盘委托每笔均量				手
1098	千档卖盘委托均价				
1099	千档卖盘委托总量				
1100	千档卖盘总档位数				
1101	买1价位委托笔数				单位priceunit=0
指标包含委托单类型、委托笔数
mmmmmmn
n=0,1,2,3 对应 小、中、大、超大 单
mmmmmm=0—999999，委托挂单笔数

该价位委托均量=该价位委托总量/(该价位委托笔数 % 1000000)
1102	买2价位委托笔数				
1103	买3价位委托笔数				
1104	买4价位委托笔数				
1105	买5价位委托笔数				
1106	买6价位委托笔数				
1107	买7价位委托笔数				
1108	买8价位委托笔数				
1109	买9价位委托笔数				
1110	买10价位委托笔数				
1111	买11价位委托笔数				
1112	买12价位委托笔数				
1113	买13价位委托笔数				
1114	买14价位委托笔数				
1115	买15价位委托笔数				
1116	买16价位委托笔数				
1117	买17价位委托笔数				
1118	买18价位委托笔数				
1119	买19价位委托笔数				
1120	买20价位委托笔数				
1121	卖1价位委托笔数				
1122	卖2价位委托笔数				
1123	卖3价位委托笔数				
1124	卖4价位委托笔数				
1125	卖5价位委托笔数				
1126	卖6价位委托笔数				
1127	卖7价位委托笔数				
1128	卖8价位委托笔数				
1129	卖9价位委托笔数				
1130	卖10价位委托笔数				
1131	卖11价位委托笔数				
1132	卖12价位委托笔数				
1133	卖13价位委托笔数				
1134	卖14价位委托笔数				
1135	卖15价位委托笔数				
1136	卖16价位委托笔数				
1137	卖17价位委托笔数				
1138	卖18价位委托笔数				
1139	卖19价位委托笔数				
1140	卖20价位委托笔数				
1141	卖k1价	AskPrice_k1	元		同3
1142	卖k2价	AskPrice_k2	元		同3
1143	卖k3价	AskPrice_k3	元		同3
1144	卖k4价	AskPrice_k4	元		同3
1145	卖k5价	AskPrice_k5	元		同3
1146	卖k6价	AskPrice_k6	元		同3
1147	卖k7价	AskPrice_k7	元		同3
1148	卖k8价	AskPrice_k8	元		同3
1149	卖k9价	AskPrice_k9	元		同3
1150	卖k10价	AskPrice_k10	元		同3
1151	卖k11价	AskPrice_k11	元		同3
1152	卖k12价	AskPrice_k12	元		同3
1153	卖k13价	AskPrice_k13	元		同3
1154	卖k14价	AskPrice_k14	元		同3
1155	卖k15价	AskPrice_k15	元		同3
1156	卖k16价	AskPrice_k16	元		同3
1157	卖k17价	AskPrice_k17	元		同3
1158	卖k18价	AskPrice_k18	元		同3
1159	卖k19价	AskPrice_k19	元		同3
1160	卖k20价	AskPrice_k20	元		同3
1161	卖k1量	AskVolume_k1	股		
1162	卖k2量	AskVolume_k2	股		
1163	卖k3量	AskVolume_k3	股		
1164	卖k4量	AskVolume_k4	股		
1165	卖k5量	AskVolume_k5	股		
1166	卖k6量	AskVolume_k6	股		
1167	卖k7量	AskVolume_k7	股		
1168	卖k8量	AskVolume_k8	股		
1169	卖k9量	AskVolume_k9	股		
1170	卖k10量	AskVolume_k10	股		
1171	卖k11量	AskVolume_k11	股		
1172	卖k12量	AskVolume_k12	股		
1173	卖k13量	AskVolume_k13	股		
1174	卖k14量	AskVolume_k14	股		
1175	卖k15量	AskVolume_k15	股		
1176	卖k16量	AskVolume_k16	股		
1177	卖k17量	AskVolume_k17	股		
1178	卖k18量	AskVolume_k18	股		
1179	卖k19量	AskVolume_k19	股		
1180	卖k20量	AskVolume_k20	股		
1181	当天火箭发射次数				
1182	当天高台跳水次数				
1183	当天封涨停次数				
1184	当天封跌停次数				
1185	当天打开涨停次数				
1186	当天打开跌停次数				
1187	上涨越过3%次数				
1188	下跌击穿-3%次数				
1189	当天创20日新高次数				如果创新高=1，否则=0
1190	当天创20日新低次数				如果创新低=1，否则=0
1191	当天MACD金叉次数				
1192	当天MACD死叉次数				
1193	当天主力挂买总量				手
1194	当天主力挂卖总量				手
1195	当天主力撤买总量				手
1196	当天主力撤卖总量				手
1197	当天主力买入总量				手
1198	当天主力卖出总量				手
1199	当天快速流入总量				手
1200	当天快速流出总量				手
1201	买价_BBQ				PriceUnit=10000
1202	卖价_BBQ				PriceUnit=10000
1203	买量_BBQ				PriceUnit=1
1204	卖量_BBQ				PriceUnit=1
1205	成交价_BBQ				PriceUnit=10000
1206	成交方式_BBQ				PriceUnit=1, ‘T’, ‘G’, ‘D’
1207	报价机构_BBQ				PriceUnit=1
1208	成交价_中债_BBQ				PriceUnit=10000
1209	成交价_中证_BBQ				PriceUnit=10000
1210	时间_BBQ				PriceUnit=1, HHMMSS
1211	日期_BBQ				PriceUnit=1,YYYYMMDD
1212	债券类型中债版				PriceUnit=1,
取值1:利率债；2:中票短融；3:PPN；4:公司债；5:ABS; 6:同业存单；7:优先股; 8:限售股；255:其它
1213	到期日距离下一交易日的天数(节假日标志)				PriceUnit=1;
1214	ETF申购笔数				PriceUnit=1
1215	ETF赎回笔数				PriceUnit=1
1216	ETF申购数量				PriceUnit=1
1217	ETF申购金额				PriceUnit=1
1218	ETF赎回数量				PriceUnit=1
1219	ETF赎回金额				PriceUnit=1
1220	涨停破板家数				PriceUnit=1; for 全A,沪A，深A,300等 
1221	跌停破板家数				PriceUnit=1; for 全A,沪A，深A,300等
1222	盘前模拟成交额				PriceUnit=1；
1223	盘前模拟换手率			%	PriceUnit=10000; 
1224	盘前涨速(5分钟涨幅)			%	PriceUnit=10000
1225	盘前振幅			%	PriceUnit=10000
1226	盘前委比			%	PriceUnit=10000
1227	盘前指数成份上涨家数				PriceUnit=1
1228	盘前指数成份下跌家数				PriceUnit=1
1229	盘前指数成份平盘家数				PriceUnit=1
1230	盘前委差				PriceUnit=1
1231	盘前买一价				同指标3
1232	盘前买二价				同指标3
1233	盘前买三价				同指标3
1234	盘前买四价				同指标3
1235	盘前买五价				同指标3
1236	盘前卖一价				同指标3
1237	盘前卖二价				同指标3
1238	盘前卖三价				同指标3
1239	盘前卖四价				同指标3
1240	盘前卖五价				同指标3
1241	盘前买一量				PriceUnit=1
1242	盘前买二量				PriceUnit=1
1243	盘前买三量				PriceUnit=1
1244	盘前买四量				PriceUnit=1
1245	盘前买五量				PriceUnit=1
1246	盘前卖一量				PriceUnit=1
1247	盘前卖二量				PriceUnit=1
1248	盘前卖三量				PriceUnit=1
1249	盘前卖四量				PriceUnit=1
1250	盘前卖五量				PriceUnit=1
1251	盘前未匹配量				PriceUnit=1
1252	盘前委买总量				PriceUnit=1
1253	盘前委卖总量				PriceUnit=1
1254	涨停封单占比		百分比		%, PriceUnit=10000, 31/214 * 10000
1255	跌停封单占比		百分比		%, PriceUnit=10000, 41/215 * 10000
1256	ADR比例				PriceUnit=10000, 小数点4位
1257	盘后成交笔数				PriceUnit=1
1258	盘后成交金额				PriceUnit=1；单位同59
1259	BBQ剩余期限				PriceUnit-1;对应907字符串显示指标的排序用；
1260	IOPV_ask1				PriceUnit=1000000; 小数点6位；
1261	IOPV_bid1				PriceUnit=1000000; 小数点6位
1262	IOPV_ask0				PriceUnit=1000000; 小数点6位
1263	IOPV_bid0				PriceUnit=1000000; 小数点6位
1264	IOPV_aska				PriceUnit=1000000; 小数点6位
1265	IOPV_bida				PriceUnit=1000000; 小数点6位
1266	当日机构净买入额				PriceUnit=1；元
1267	当日大户净买入额				PriceUnit=1
1268	当日中户净买入额				PriceUnit=1
1269	当日散户净买入额				PriceUnit=1
1270	虚拟成交量				PriceUnit=1
1271	W量比				PriceUnit=10000
1272	涨跌比			%	PriceUnit=10000
1273	前隐含波动率			%	PriceUnit=10000
1274	隐含波动率涨跌幅			%	PriceUnit=10000
1275	虚拟成交额				PriceUnit=1
1276	最优买卖价差				买1-卖1； PriceUnit 同 3指标
1277	较发行价涨跌幅			%	PriceUnit=10000
1278	IOPV2溢折率			%	PriceUnit=10000
1279	预估净值昨收				PriceUnit=10000
1280					
1281					
1282					
1283					
1284					
1285					
1286					
1287					
1288					
1289					
1290					
1291					
1292					
1293					
1294					
1295					
1296					
1297					
1298					
1299					
1300					
1301					
1302					
1303					
1304					
1305					
1306					
1307					
1308					
1309					
1310					
					


L2_StreamPacket(326) 动态子指标：
2202: 逐笔成交类型；不放在一般指标中；Tick收到后进行过滤用，不会发送到客户端；
1984: 动态板块成分；不放在一般指标中；Tick收到后更新动态板块；客户端定时刷新；
---帮我转换为Java枚举类
```





























