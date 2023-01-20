## 두가지의 Relay

- Subject를 래핑하고 있는 두가지의 Relay를 제공
- Relay는 Subject와 마찬가지로 다른 소스로부터 이벤트를 받아 구독자에게 전달
- 가장 큰 차이 → **Subject와 달리 넥스트 이벤트만 받고 컴플리트와 에러는 받지 않음**
    - Subject와 달리 종료되지 않음 → 구독자가 disposed 되기 전까지 이벤트를 계속 처리
- 종료 없이 계속 실행되는 시퀀스를 만들 때 사용
- 주로 UI 이벤트 처리에 활용
- subscribe 하고 싶을 때는 asObservable을 사용

### **PublishRelay**

- **PublishSubject를 래핑**
- Subject 는 `.completed` 나 `.error`를 받으면 subscribe이 종료. 하지만 PublishRelay는 dispose되기 전까지 계속 작동하기 때문에 UI Event에서 사용하기 적절

### **BehaviorRelay**

- **BehaviorSubject를 래핑**
- `.value`를 사용해 현재의 값을 꺼낼 수 있음
- `.value`의 경우 get-only-property 이므로 유의
- value를 변경하기 위해서 `.accept()`를 사용

### Replay**Relay**

- **ReplaySubject를 래핑**
- ReplaySubject와 동일하게 bufferSize개의 이벤트를 저장해 subscribe 될 때 저장된 이벤트를 모두 방출