import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/models/insect_alert_model.dart';
import 'package:pest_lens_app/services/insect_record_service.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/insect_alert_bar_chart.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AverageInsectAmountPage extends StatefulWidget {
  final String insectName;

  const AverageInsectAmountPage({super.key, required this.insectName});

  @override
  _AverageInsectAmountPageState createState() =>
      _AverageInsectAmountPageState();
}

class _AverageInsectAmountPageState extends State<AverageInsectAmountPage> {
  final InsectRecordService _insectRecordService = InsectRecordService();
  InsectAlertModel? _selectedInsectAlert;

  @override
  void initState() {
    super.initState();
    _fetchInsectAlerts();
  }

  Future<void> _fetchInsectAlerts() async {
    final alerts = await _insectRecordService.fetchInsectAlerts();
    setState(() {
      _selectedInsectAlert = alerts.firstWhere(
        (alert) => alert.englishName == widget.insectName,
        orElse: () => throw Exception('Insect not found'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.averageInsectAmount,
          style: CustomTextStyles.pageTitle2,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const MyBackButton(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        elevation: 0,
      ),
      body: _selectedInsectAlert == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InsectAlertBarChart(insectAlert: _selectedInsectAlert!),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: AppLocalizations.of(context)!.insectInfo,
                      content: _buildInsectInfo(),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: AppLocalizations.of(context)!.countDetails,
                      content: _buildCountDetails(),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: AppLocalizations.of(context)!.chartDescription,
                      content: Text(_selectedInsectAlert!.alertMessage,
                          style: CustomTextStyles.cardContent),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget content}) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: CustomTextStyles.cardTitle,
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildInsectInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBoldLabelText(
          AppLocalizations.of(context)!.englishName,
          _selectedInsectAlert!.englishName,
        ),
        const SizedBox(height: 4),
        _buildBoldLabelText(
          AppLocalizations.of(context)!.vietnameseName,
          _selectedInsectAlert!.vietnameseName,
        ),
      ],
    );
  }

  Widget _buildCountDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBoldLabelText(
          AppLocalizations.of(context)!.previousCount,
          _selectedInsectAlert!.previousCount.toString(),
        ),
        const SizedBox(height: 4),
        _buildBoldLabelText(
          AppLocalizations.of(context)!.currentCount,
          _selectedInsectAlert!.currentCount.toString(),
        ),
        const SizedBox(height: 4),
        _buildBoldLabelText(
          AppLocalizations.of(context)!.percentageIncrease,
          '${_selectedInsectAlert!.percentageIncrease.toStringAsFixed(2)}%',
        ),
        const SizedBox(height: 4),
        _buildBoldLabelText(
          AppLocalizations.of(context)!.dateRange,
          '${_formatDate(_selectedInsectAlert!.startDate)} - ${_formatDate(_selectedInsectAlert!.endDate)}',
        ),
      ],
    );
  }

  Widget _buildBoldLabelText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: CustomTextStyles.cardContent,
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
