## Subject?

- 옵저버블은 이벤트를 전달, 옵저버는 옵저버블을 구독하고 이벤트를 처리한다.
- 옵저버블은 옵저버와 달리 다른 옵저버블을 구독하지 못함
- 옵저버는 다른 옵저버로 이벤트를 전달하지 못함
- 반면 **subject는 다른 옵저버블로부터 이벤트를 받아서 구독자로 전달할 수 있다**
- **즉, Subject는 옵저버블인 동시에 옵저버**
- 실시간으로 Observable에 값을 추가하고 Subscriber에게 방출하는 것이 필요할 때 사용
- **Subject**를 사용하면 Cold Observable을 Hot Observable로 변환 할 수 있다.

### Hot Observable

- 생성과 동시에 이벤트를 방출하기 시작하는 Observable
- Subscribe 되는 시점과 상관없이 Observer 에게 이벤트를 중간부터 전송

### **Cold Observable**

- Subscribe 되는 시점부터 이벤트를 생성해 방출합니다.

### ****Subscription 공유****

- Cold Observable 은 subscribe 되는 시점부터 이벤트를 생성해 방출
- 여러번의 subcribe 가 있을 때마다 스트림이 중복으로 발생하게 됨

## 4가지의 Subject

**PublishSubject**

- 서브젝트로 전달되는 새로운 이벤트를 구독자에게 전달
- PubishSubject는 subscribe된 이후부터 이벤트를 방출

**BehaviorSubject**

- 생성시점에 시작 이벤트를 지정, 그리고 서브젝트로 전달되는 이벤트 중에 가장 마지막에 전달된 최신 이벤트를 저장해두었다가, 구독자에게 전달
- PublishSubject 와 비슷하지만 초기 이벤트를 가진 Subject. subscribe 될때 가장 최신의 .next 이벤트를 전달
- BehaviorSubject는 항상 최신의 `.next` 이벤트를 방출하기 때문에 초기값 없이는 만들 수 없음. 초기값이 없다면 PublishSubject를 사용
- **사용 :** 항상 최신 데이터로 채워놓아야 하는 경우에 사용 (유저 프로필)

**ReplaySubject**

- 하나 이상의 최신 이벤트를 버퍼에 저장
- 옵저버가 구독을 시작하면 버퍼에 있는 모든 이벤트를 전달
- ReplaySubject는 bufferSize 개의 이벤트를 저장해 subscribe 될 때 저장된 이벤트를 모두 방출
- **사용 :** 최신의 여러 값들을 보여주고 싶을 때 사용 (최근 검색어)

**AsyncSubject**

- 서브젝트로 컴플리트 이벤트가 전달되는 시점에 마지막에 전달된 넥스트 이벤트를 구독자에게 전달한다.
- 에러 이벤트에서는 넥스트이벤트가 전달되지 않는다.