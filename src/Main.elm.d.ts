export namespace Elm {
    namespace Main {
        interface App {
            ports: Ports;
        }

        interface Ports {
        }

        interface Subscribe<CallbackArg> {
            subscribe(callback: subscribeCallback<CallbackArg>): void;
        }

        type subscribeCallback<Arg> = (v: Arg) => void;

        interface Send<T> {
            send(value: T): void;
        }

        function init(): App;

        // interface Args {
        //     node: HTMLElement;
            // flags: any;
        // }
    }
}
