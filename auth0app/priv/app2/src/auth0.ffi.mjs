import {Ok} from "./gleam.mjs";

export function promiseTest() {
    return new Promise((resolve) => {
        // setTimeout(() => { console.log("Hello!"); }, 2000);
        window.setTimeout(() => {
            resolve(new Ok("hello!"))
        }, 10000)
    })
}