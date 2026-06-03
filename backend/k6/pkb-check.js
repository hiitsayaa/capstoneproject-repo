import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 50 },
    { duration: '1m', target: 50 },
    { duration: '30s', target: 0 },
  ],
};

export default function () {
  const url = 'http://localhost:3000/bapenda/pkb/check?nopol=N1234AB';
  const params = {
    headers: {
      Authorization: 'Bearer test-mock-token',
    },
  };
  const res = http.get(url, params);

  check(res, {
    'status is 200': (response) => response.status === 200,
    'response time < 150ms': (response) => response.timings.duration < 150,
  });

  sleep(1);
}
