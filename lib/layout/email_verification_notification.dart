import 'package:flutter/material.dart';
import 'package:social_app/shared/cubit/cubit.dart';

class EmailVerificationNotification extends StatelessWidget {
  final AppCubit appCubit;
  const EmailVerificationNotification({super.key, required this.appCubit});

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    );
    return Column(
      children: [
        Container(
          color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Text(
                      "Verify your e-mail !",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                TextButton(
                  onPressed: () => appCubit.sendEmailVerification(),
                  child: const Text(
                    "Send",
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () => appCubit.updateEmailVerification(),
          child: const Text(
            "refresh",
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
