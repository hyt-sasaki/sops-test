package main

import (
    "dagger.io/dagger"
    "dagger.io/dagger/core"
    "universe.dagger.io/aws"
)

dagger.#Plan & {
    client: {
        commands: sts: {
            name: "aws"
            args: ["sts", "assume-role", "--role-arn", "arn:aws:iam::146161350821:role/kms_use_role", "--role-session-name", "AWSCLIsession"]
            stdout: dagger.#Secret
        }
    }

    actions: {
        awsSecrets: core.#DecodeSecret & {
            format: "json"
            input: client.commands.sts.stdout
        }
        _credential: awsSecrets.output.Credentials
        getCallerIdentity: aws.#Container & {
            credentials: aws.#Credentials & {
                accessKeyId: _credential.AccessKeyId.contents
                secretAccessKey: _credential.SecretAccessKey.contents
                sessionToken: _credential.SessionToken.contents
            }
            env: {
                AWS_EC2_METADATA_DISABLED: "true"
                // NO_PROXY: "localhost,127.0.0.1,169.254.169.254"
            }
            command: {
                name: "aws"
                args: ["sts", "get-caller-identity", "--debug"]
            }
        }
    }
}
