import { Kafka } from 'kafkajs';
import { com } from '../generated/proto';

const { Transaction } = com.clickhouse_kafka.kafka;

const kafka = new Kafka({
  clientId: 'my-app',
  brokers: ['localhost:9092']
});

const producer = kafka.producer();

async function func() {
  await producer.connect();
  for (let i = 5; i > 0; --i) {
    await producer.send({
      topic: 'test',
      messages: [
        { value: Buffer.from(Transaction.encodeDelimited({key: `wtf ${i}`, num: i}).finish()) }
      ]
    });
  }
  await producer.disconnect();
}

func()
.then((el: any) => { console.log(`${el}`); })
.catch((el: any) => { console.log(`${el}`); });
