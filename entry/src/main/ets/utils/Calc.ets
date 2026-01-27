import { taskpool } from '@kit.ArkTS';

@Concurrent
export function fibonacci(n: number): number {
  // 定义内部函数以满足递归调用时的"局部变量"严格规则
  let impl = (num: number): number => {
    if (num <= 1) return num;
    return impl(num - 1) + impl(num - 2);
  };
  return impl(n);
}
